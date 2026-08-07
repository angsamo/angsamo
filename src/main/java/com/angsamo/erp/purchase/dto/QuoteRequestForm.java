package com.angsamo.erp.purchase.dto;

import java.util.ArrayList;
import java.util.List;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class QuoteRequestForm {

    @NotEmpty(message = "협력업체를 한 곳 이상 선택하세요.")
    @Size(min = 2, message = "비교 견적을 위해 협력업체를 두 곳 이상 선택하세요.")
    private List<Long> vendorIds = new ArrayList<>();
}
