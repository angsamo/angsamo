package com.angsamo.erp.common.dashboard;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class StatusSegment {
	private String status;
	private String label;
	private String colorClass;
	private long count;
	private double percent;
	private int stepIndex;
	private boolean exceptionStatus;
}
