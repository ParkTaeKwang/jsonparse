package kr.co.shop.jsonparse.mapper;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.shop.jsonparse.cmmn.annotation.mapper.MapperCUD;
import kr.co.shop.jsonparse.vo.JsontestVO;

@MapperCUD
@Mapper("indexMapperCUD")
public interface IndexMapperCUD {

	/**
	 * jsontest 테스트
	 * @param jsontestVO
	 * @return 
	 */
	public int insertJsontest(JsontestVO jsontestVO);
}
