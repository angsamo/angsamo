package com.angsamo.erp.common.web;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {
	private final AdminInterceptor adminInterceptor;
	private final DepartmentAccessInterceptor departmentAccessInterceptor;

	@Value("${safety.upload-dir}")
	private String safetyUploadDir;

	public WebConfig(AdminInterceptor adminInterceptor, DepartmentAccessInterceptor departmentAccessInterceptor) {
		this.adminInterceptor = adminInterceptor;
		this.departmentAccessInterceptor = departmentAccessInterceptor;
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(adminInterceptor).addPathPatterns("/admin/**", "/safety/**", "/safety");
		registry.addInterceptor(departmentAccessInterceptor)
				.addPathPatterns("/development/**", "/production/**", "/material/**", "/purchase/**",
						"/vendor/**", "/supplier/**", "/vendor", "/supplier");
	}

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/safety/uploads/**")
				.addResourceLocations("file:" + safetyUploadDir + "/");
	}
}
