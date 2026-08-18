package com.angsamo.erp.safety.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.angsamo.erp.safety.domain.SafetyCheckItem;
import com.angsamo.erp.safety.domain.SafetyChecklist;

@Mapper
public interface SafetyChecklistMapper {

    List<SafetyChecklist> findAll();

    SafetyChecklist findById(@Param("checklistId") Long checklistId);

    SafetyChecklist findActive();

    int insertChecklist(SafetyChecklist checklist);

    int updateStatus(@Param("checklistId") Long checklistId, @Param("status") String status);

    List<SafetyCheckItem> findItemsByChecklistId(@Param("checklistId") Long checklistId);

    List<SafetyCheckItem> findRecentHelmetOffItems(@Param("limit") int limit);

    int insertItem(SafetyCheckItem item);
}
