package kr.co.shop.jsonparse.service.impl;

import java.util.List;

import static com.google.common.base.Preconditions.checkArgument;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.shop.jsonparse.mapper.IndexMapperCUD;
import kr.co.shop.jsonparse.mapper.IndexMapperR;
import kr.co.shop.jsonparse.service.IndexService;
import kr.co.shop.jsonparse.vo.JsontestVO;
import lombok.extern.slf4j.Slf4j;


@Slf4j
@Service
public class IndexServiceImpl implements IndexService {
	
	@Autowired
	private IndexMapperR indexMapperR;
	
	@Autowired
	private IndexMapperCUD indexMapperCUD;

	@Override
	public List<JsontestVO> getJsontestList() {
		return indexMapperR.selectJsontestList();

	}

	@Override
	public void setJsontest(JsontestVO jsontestVO) {
		checkArgument(indexMapperCUD.insertJsontest(jsontestVO) > 0, "jsontest 저장에 실패 했습니다.");
	}
	
}
