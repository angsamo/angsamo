package com.angsamo.erp.development;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

import org.junit.jupiter.api.Test;

import com.angsamo.erp.development.mapper.BomMapper;
import com.angsamo.erp.development.mapper.ItemMapper;
import com.angsamo.erp.development.service.BomService;
import com.angsamo.erp.development.service.ItemService;

class DevelopmentSearchServiceTests {

    @Test
    void itemSearchTrimsKeywordAndNormalizesType() {
        ItemMapper itemMapper = mock(ItemMapper.class);
        ItemService service = new ItemService(itemMapper);

        service.search("  MAT-001  ", " material ");

        verify(itemMapper).search("MAT-001", "MATERIAL");
    }

    @Test
    void blankBomKeywordBecomesNull() {
        BomMapper bomMapper = mock(BomMapper.class);
        ItemMapper itemMapper = mock(ItemMapper.class);
        BomService service = new BomService(bomMapper, itemMapper);

        service.search("   ");

        verify(bomMapper).search(null);
    }
}
