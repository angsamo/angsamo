package com.angsamo.erp.production.service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Service;

import com.angsamo.erp.common.session.LoginUser;
import com.angsamo.erp.development.domain.Item;
import com.angsamo.erp.development.mapper.ItemMapper;
import com.angsamo.erp.production.domain.ProductionPlan;
import com.angsamo.erp.production.mapper.ProductionPlanMapper;

@Service
public class ProductionPlanService {

    private static final Set<String> ALLOWED_STATUSES = Set.of(
            "PLANNED",
            "IN_PROGRESS",
            "COMPLETED",
            "CANCELLED"
    );

    private final ProductionPlanMapper productionPlanMapper;
    private final ItemMapper itemMapper;

    public ProductionPlanService(
            ProductionPlanMapper productionPlanMapper,
            ItemMapper itemMapper
    ) {
        this.productionPlanMapper = productionPlanMapper;
        this.itemMapper = itemMapper;
    }

    // 생산계획 목록 조회
    public List<ProductionPlan> findAll() {
        return productionPlanMapper.findAll();
    }

    // 생산계획 상세 조회
    public ProductionPlan findById(Long productionPlanId) {
        if (productionPlanId == null) {
            return null;
        }

        return productionPlanMapper.findById(productionPlanId);
    }

    // 생산계획 등록
    public Long insert(
            ProductionPlan productionPlan,
            LoginUser loginUser
    ) {
        validateProductionPermission(loginUser);
        validateCreateForm(productionPlan);

        Item item = itemMapper.findByItemId(
                productionPlan.getItemId()
        );

        if (item == null) {
            throw new IllegalArgumentException(
                    "선택한 생산 품목을 찾을 수 없습니다."
            );
        }

        if (!"PRODUCT".equals(item.getItemType())) {
            throw new IllegalArgumentException(
                    "생산계획에는 완제품만 선택할 수 있습니다."
            );
        }

        if (loginUser.getDepartmentId() == null) {
            throw new IllegalStateException(
                    "로그인 사용자의 부서 정보가 없습니다."
            );
        }

        if (loginUser.getUserId() == null) {
            throw new IllegalStateException(
                    "로그인 사용자 정보가 없습니다."
            );
        }

        productionPlan.setDepartmentId(
                loginUser.getDepartmentId()
        );

        productionPlan.setCreatedBy(
                loginUser.getUserId()
        );

        productionPlan.setStatus("PLANNED");

        int insertedCount =
                productionPlanMapper.insert(productionPlan);

        if (insertedCount == 0) {
            throw new IllegalStateException(
                    "생산계획을 등록하지 못했습니다."
            );
        }

        return productionPlan.getProductionPlanId();
    }

    // 생산 수량 및 일정 수정
    public void update(
            ProductionPlan productionPlan,
            LoginUser loginUser
    ) {
        validateProductionPermission(loginUser);

        if (productionPlan == null
                || productionPlan.getProductionPlanId() == null) {

            throw new IllegalArgumentException(
                    "수정할 생산계획 정보가 없습니다."
            );
        }

        ProductionPlan existingPlan =
                productionPlanMapper.findById(
                        productionPlan.getProductionPlanId()
                );

        if (existingPlan == null) {
            throw new IllegalArgumentException(
                    "수정할 생산계획을 찾을 수 없습니다."
            );
        }

        validateDepartmentAccess(existingPlan, loginUser);
        validateQuantityAndDates(productionPlan);

        int updatedCount =
                productionPlanMapper.update(productionPlan);

        if (updatedCount == 0) {
            throw new IllegalStateException(
                    "생산계획을 수정하지 못했습니다."
            );
        }
    }

    // 생산계획 상태 변경
    public void updateStatus(
            Long productionPlanId,
            String status,
            LoginUser loginUser
    ) {
        validateProductionPermission(loginUser);

        if (productionPlanId == null) {
            throw new IllegalArgumentException(
                    "생산계획 번호가 없습니다."
            );
        }

        ProductionPlan existingPlan =
                productionPlanMapper.findById(productionPlanId);

        if (existingPlan == null) {
            throw new IllegalArgumentException(
                    "상태를 변경할 생산계획을 찾을 수 없습니다."
            );
        }

        validateDepartmentAccess(existingPlan, loginUser);

        String normalizedStatus =
                status == null ? "" : status.trim().toUpperCase();

        if (!ALLOWED_STATUSES.contains(normalizedStatus)) {
            throw new IllegalArgumentException(
                    "올바르지 않은 생산계획 상태입니다."
            );
        }

        int updatedCount =
                productionPlanMapper.updateStatus(
                        productionPlanId,
                        normalizedStatus
                );

        if (updatedCount == 0) {
            throw new IllegalStateException(
                    "생산계획 상태를 변경하지 못했습니다."
            );
        }
    }

    // 등록값 검증
    private void validateCreateForm(
            ProductionPlan productionPlan
    ) {
        if (productionPlan == null) {
            throw new IllegalArgumentException(
                    "생산계획 정보가 없습니다."
            );
        }

        if (productionPlan.getItemId() == null) {
            throw new IllegalArgumentException(
                    "생산할 완제품을 선택해 주세요."
            );
        }

        validateQuantityAndDates(productionPlan);
    }

    // 수량과 날짜 검증
    private void validateQuantityAndDates(
            ProductionPlan productionPlan
    ) {
        BigDecimal productionQty =
                productionPlan.getProductionQty();

        if (productionQty == null
                || productionQty.compareTo(BigDecimal.ZERO) <= 0) {

            throw new IllegalArgumentException(
                    "생산 수량은 0보다 커야 합니다."
            );
        }

        LocalDate startDate =
                productionPlan.getStartDate();

        LocalDate dueDate =
                productionPlan.getDueDate();

        if (startDate == null) {
            throw new IllegalArgumentException(
                    "생산 시작일을 입력해 주세요."
            );
        }

        if (dueDate == null) {
            throw new IllegalArgumentException(
                    "완료 예정일을 입력해 주세요."
            );
        }

        if (startDate.isAfter(dueDate)) {
            throw new IllegalArgumentException(
                    "생산 시작일은 완료 예정일보다 늦을 수 없습니다."
            );
        }
    }

    // 생산계획 등록·수정 권한 검사
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

    // 자기 부서 생산계획 수정 여부 검사
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
                    "다른 부서의 생산계획은 수정할 수 없습니다."
            );
        }
    }
}