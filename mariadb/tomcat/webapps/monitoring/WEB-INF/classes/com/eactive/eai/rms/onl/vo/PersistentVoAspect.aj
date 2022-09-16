package com.eactive.eai.rms.onl.vo;

import com.eactive.eai.rms.common.datasource.DataSourceContextHolder;

public aspect PersistentVoAspect {

    public String PersistentVo.getSchemaId() {
        return DataSourceContextHolder.getDataSourceType().getSchema();
    }

}
