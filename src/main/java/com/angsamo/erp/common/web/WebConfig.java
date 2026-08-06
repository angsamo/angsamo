package com.angsamo.erp.common.web;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
	private final AdminInterceptor adminInterceptor;
	private final MaterialAccessInterceptor materialAccessInterceptor;

	public WebConfig(AdminInterceptor adminInterceptor, MaterialAccessInterceptor materialAccessInterceptor) {
		this.adminInterceptor = adminInterceptor;
		this.materialAccessInterceptor = materialAccessInterceptor;
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(adminInterceptor).addPathPatterns("/admin/**");
		registry.addInterceptor(materialAccessInterceptor).addPathPatterns("/material/**", "/material");
	}
}
