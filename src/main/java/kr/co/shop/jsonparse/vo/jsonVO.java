package kr.co.shop.jsonparse.vo;

import java.io.Serializable;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class jsonVO implements Serializable {

	private static final long serialVersionUID = 433998533810083144L;
		
	private String num;
	
	private String blockHash;
    private String contractAddress;
    
    private String transactionIndex;
    private String confirmations;
    
    private String nonce;  
    private String timeStamp;
    
    
    private String input;
    private String gasUsed;
    
    
    private String isError;
    private String txreceipt_status;
    
    private String blockNumber;
    private String gas;
    
    
    private String cumulativeGasUsed;
    private String from;
    
    private String to;
    private String value;
    
    private String hash;    
    private String gasPrice;

}
