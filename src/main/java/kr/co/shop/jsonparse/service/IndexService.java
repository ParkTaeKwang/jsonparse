package kr.co.shop.jsonparse.service;

import java.util.List;

import kr.co.shop.jsonparse.service.impl.IndexServiceImpl;
import kr.co.shop.jsonparse.vo.JsontestVO;

public interface IndexService {

	/**
	 * jsontest
	 * @return JsontestVO 
	 */
	public List<JsontestVO> getJsontestList();
	
	/**
	 * jsontest 
	 * @param JsontestVO
	 */
	public void setJsontest(JsontestVO jsontestVO);
}
