package com.angsamo.erp.common.web;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
	private final AdminInterceptor adminInterceptor;
	private final DepartmentAccessInterceptor departmentAccessInterceptor;

	public WebConfig(AdminInterceptor adminInterceptor, DepartmentAccessInterceptor departmentAccessInterceptor) {
		this.adminInterceptor = adminInterceptor;
		this.departmentAccessInterceptor = departmentAccessInterceptor;
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(adminInterceptor).addPathPatterns("/admin/**");
		registry.addInterceptor(departmentAccessInterceptor)
				.addPathPatterns("/development/**", "/production/**", "/material/**", "/purchase/**",
						"/vendor/**", "/supplier/**", "/vendor", "/supplier");
	}
}
