package kr.co.shop.jsonparse.vo;

import java.io.Serializable;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class JsontestVO implements Serializable {

	private static final long serialVersionUID = 3339985970810083144L;
	
	private int num;				
	private String hash;
	private String contents;
	private String regDate;			
}
