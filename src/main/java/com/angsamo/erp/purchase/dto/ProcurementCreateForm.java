package com.angsamo.erp.purchase.dto;

import java.time.LocalDate;

import jakarta.validation.constraints.FutureOrPresent;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProcurementCreateForm {

    @NotNull(message = "자재요청을 선택하세요.")
    private Long materialRequestId;

    @NotNull(message = "견적 마감일을 입력하세요.")
    @FutureOrPresent(message = "견적 마감일은 오늘 이후여야 합니다.")
    private LocalDate quoteDeadline;
}
