package com.angsamo.erp.purchase.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class VendorForm {

    @NotBlank(message = "업체코드를 입력하세요.")
    @Size(max = 30, message = "업체코드는 30자 이하여야 합니다.")
    private String vendorCode;

    @NotBlank(message = "업체명을 입력하세요.")
    @Size(max = 100, message = "업체명은 100자 이하여야 합니다.")
    private String vendorName;

    @Size(max = 100)
    private String contactName;

    @Size(max = 30)
    private String phone;

    @Email(message = "이메일 형식이 올바르지 않습니다.")
    @Size(max = 150)
    private String email;

    @Size(max = 300)
    private String address;

    private Boolean active = true;
}
