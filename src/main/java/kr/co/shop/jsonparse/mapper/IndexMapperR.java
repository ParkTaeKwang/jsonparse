package kr.co.shop.jsonparse.mapper;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import kr.co.shop.jsonparse.cmmn.annotation.mapper.MapperR;
import kr.co.shop.jsonparse.vo.JsontestVO;

@MapperR
@Mapper("indexMapperR")
public interface IndexMapperR {

	/**
	 * jsontest
	 * @return JsontestVO 
	 * 	 */
	public List<JsontestVO> selectJsontestList();
}
