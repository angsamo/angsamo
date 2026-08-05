package com.angsamo.erp.production.service;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.angsamo.erp.common.session.LoginUser;
import com.angsamo.erp.development.domain.Bom;
import com.angsamo.erp.development.mapper.BomMapper;
import com.angsamo.erp.production.domain.MaterialRequest;
import com.angsamo.erp.production.domain.ProductionPlan;
import com.angsamo.erp.production.mapper.MaterialRequestMapper;
import com.angsamo.erp.production.mapper.ProductionPlanMapper;

@Service
public class MaterialRequestService {

    private final MaterialRequestMapper materialRequestMapper;
    private final ProductionPlanMapper productionPlanMapper;
    private final BomMapper bomMapper;

    public MaterialRequestService(
            MaterialRequestMapper materialRequestMapper,
            ProductionPlanMapper productionPlanMapper,
            BomMapper bomMapper
    ) {
        this.materialRequestMapper = materialRequestMapper;
        this.productionPlanMapper = productionPlanMapper;
        this.bomMapper = bomMapper;
    }

    // 자재요청 전체 목록 조회
    public List<MaterialRequest> findAll() {
        return materialRequestMapper.findAll();
    }

    // 자재요청 상세 조회
    public MaterialRequest findById(Long requestId) {
        if (requestId == null) {
            return null;
        }

        return materialRequestMapper.findById(requestId);
    }

    // 특정 생산계획의 자재요청 목록 조회
    public List<MaterialRequest> findByProductionPlanId(
            Long productionPlanId
    ) {
        if (productionPlanId == null) {
            throw new IllegalArgumentException(
                    "생산계획 번호가 없습니다."
            );
        }

        return materialRequestMapper.findByProductionPlanId(
                productionPlanId
        );
    }

    // 생산계획의 BOM을 기준으로 기본 자재요청 생성
    @Transactional
    public int createFromProductionPlan(
            Long productionPlanId,
            LoginUser loginUser
    ) {
        validateProductionPermission(loginUser);

        if (productionPlanId == null) {
            throw new IllegalArgumentException(
                    "생산계획 번호가 없습니다."
            );
        }

        ProductionPlan productionPlan =
                productionPlanMapper.findById(productionPlanId);

        if (productionPlan == null) {
            throw new IllegalArgumentException(
                    "자재요청을 생성할 생산계획을 찾을 수 없습니다."
            );
        }

        validateDepartmentAccess(productionPlan, loginUser);

        if (productionPlan.getProductionQty() == null
                || productionPlan.getProductionQty()
                        .compareTo(BigDecimal.ZERO) <= 0) {

            throw new IllegalStateException(
                    "생산계획의 생산 수량이 올바르지 않습니다."
            );
        }

        if (productionPlan.getDepartmentId() == null) {
            throw new IllegalStateException(
                    "생산계획의 담당 부서 정보가 없습니다."
            );
        }

        if (productionPlan.getDueDate() == null) {
            throw new IllegalStateException(
                    "생산계획의 완료 예정일 정보가 없습니다."
            );
        }

        if (loginUser.getUserId() == null) {
            throw new IllegalStateException(
                    "로그인 사용자 정보가 없습니다."
            );
        }

        List<Bom> bomItems =
                bomMapper.findByParentItemId(
                        productionPlan.getItemId()
                );

        if (bomItems == null || bomItems.isEmpty()) {
            throw new IllegalStateException(
                    "생산 품목에 등록된 BOM 구성 자재가 없습니다."
            );
        }

        int createdCount = 0;

        for (Bom bom : bomItems) {
            if (bom.getComponentItemId() == null) {
                throw new IllegalStateException(
                        "BOM 구성 자재 정보가 올바르지 않습니다."
                );
            }

            if (bom.getRequiredQty() == null
                    || bom.getRequiredQty()
                            .compareTo(BigDecimal.ZERO) <= 0) {

                throw new IllegalStateException(
                        "BOM 필요 수량이 올바르지 않습니다."
                );
            }

            int duplicateCount =
                    materialRequestMapper
                            .countByProductionPlanIdAndItemId(
                                    productionPlanId,
                                    bom.getComponentItemId()
                            );

            if (duplicateCount > 0) {
                continue;
            }

            BigDecimal requestQty =
                    productionPlan.getProductionQty()
                            .multiply(bom.getRequiredQty());

            MaterialRequest materialRequest =
                    new MaterialRequest();

            materialRequest.setProductionPlanId(
                    productionPlanId
            );

            materialRequest.setDepartmentId(
                    productionPlan.getDepartmentId()
            );

            materialRequest.setItemId(
                    bom.getComponentItemId()
            );

            materialRequest.setRequestQty(
                    requestQty
            );

            materialRequest.setIssuedQty(
                    BigDecimal.ZERO
            );

            materialRequest.setRequiredDate(
                    productionPlan.getDueDate()
            );

            materialRequest.setStatus(
                    "REQUESTED"
            );

            materialRequest.setRequestedBy(
                    loginUser.getUserId()
            );

            int insertedCount =
                    materialRequestMapper.insert(
                            materialRequest
                    );

            if (insertedCount == 0) {
                throw new IllegalStateException(
                        "자재요청을 생성하지 못했습니다."
                );
            }

            createdCount++;
        }

        if (createdCount == 0) {
            throw new IllegalStateException(
                    "이미 모든 구성 자재 요청이 생성되어 있습니다."
            );
        }

        return createdCount;
    }

    // REQUESTED 상태 요청 수정
    public void updateRequested(
            MaterialRequest materialRequest,
            LoginUser loginUser
    ) {
        validateProductionPermission(loginUser);

        if (materialRequest == null
                || materialRequest.getRequestId() == null) {

            throw new IllegalArgumentException(
                    "수정할 자재요청 정보가 없습니다."
            );
        }

        MaterialRequest existingRequest =
                materialRequestMapper.findById(
                        materialRequest.getRequestId()
                );

        if (existingRequest == null) {
            throw new IllegalArgumentException(
                    "수정할 자재요청을 찾을 수 없습니다."
            );
        }

        validateRequestDepartmentAccess(
                existingRequest,
                loginUser
        );

        if (!"REQUESTED".equals(existingRequest.getStatus())) {
            throw new IllegalStateException(
                    "REQUESTED 상태의 자재요청만 수정할 수 있습니다."
            );
        }

        if (materialRequest.getRequestQty() == null
                || materialRequest.getRequestQty()
                        .compareTo(BigDecimal.ZERO) <= 0) {

            throw new IllegalArgumentException(
                    "요청 수량은 0보다 커야 합니다."
            );
        }

        if (materialRequest.getRequiredDate() == null) {
            throw new IllegalArgumentException(
                    "필요일을 입력해 주세요."
            );
        }

        int updatedCount =
                materialRequestMapper.updateRequested(
                        materialRequest
                );

        if (updatedCount == 0) {
            throw new IllegalStateException(
                    "자재요청을 수정하지 못했습니다."
            );
        }
    }

    // REQUESTED 상태 요청 취소
    public void cancelRequested(
            Long requestId,
            LoginUser loginUser
    ) {
        validateProductionPermission(loginUser);

        if (requestId == null) {
            throw new IllegalArgumentException(
                    "취소할 자재요청 번호가 없습니다."
            );
        }

        MaterialRequest existingRequest =
                materialRequestMapper.findById(requestId);

        if (existingRequest == null) {
            throw new IllegalArgumentException(
                    "취소할 자재요청을 찾을 수 없습니다."
            );
        }

        validateRequestDepartmentAccess(
                existingRequest,
                loginUser
        );

        if (!"REQUESTED".equals(existingRequest.getStatus())) {
            throw new IllegalStateException(
                    "REQUESTED 상태의 자재요청만 취소할 수 있습니다."
            );
        }

        int updatedCount =
                materialRequestMapper.cancelRequested(requestId);

        if (updatedCount == 0) {
            throw new IllegalStateException(
                    "자재요청을 취소하지 못했습니다."
            );
        }
    }

    // 생산부서 또는 관리자 권한 검사
    private void validateProductionPermission(
            LoginUser loginUser
    ) {
        if (loginUser == null) {
            throw new IllegalStateException(
                    "로그인이 필요합니다."
            );
        }

        boolean admin =
                "ADMIN".equals(loginUser.getRole());

        boolean productionDepartment =
                "PRODUCTION".equals(
                        loginUser.getDepartmentCode()
                );

        if (!admin && !productionDepartment) {
            throw new IllegalStateException(
                    "생산부서 또는 관리자만 처리할 수 있습니다."
            );
        }
    }

    // 생산계획 부서 접근 검사
    private void validateDepartmentAccess(
            ProductionPlan productionPlan,
            LoginUser loginUser
    ) {
        if ("ADMIN".equals(loginUser.getRole())) {
            return;
        }

        if (loginUser.getDepartmentId() == null
                || productionPlan.getDepartmentId() == null
                || !loginUser.getDepartmentId().equals(
                        productionPlan.getDepartmentId()
                )) {

            throw new IllegalStateException(
                    "다른 부서의 생산계획에는 자재요청을 생성할 수 없습니다."
            );
        }
    }

    // 자재요청 부서 접근 검사
    private void validateRequestDepartmentAccess(
            MaterialRequest materialRequest,
            LoginUser loginUser
    ) {
        if ("ADMIN".equals(loginUser.getRole())) {
            return;
        }

        if (loginUser.getDepartmentId() == null
                || materialRequest.getDepartmentId() == null
                || !loginUser.getDepartmentId().equals(
                        materialRequest.getDepartmentId()
                )) {

            throw new IllegalStateException(
                    "다른 부서의 자재요청은 수정하거나 취소할 수 없습니다."
            );
        }
    }
}