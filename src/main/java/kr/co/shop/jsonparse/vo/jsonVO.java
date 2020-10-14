package kr.co.shop.jsonparse.vo;

import java.io.Serializable;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class jsonVO implements Serializable {

	private static final long serialVersionUID = 433998533810083144L;
	
	private String blockNumber;
    private String timeStamp;
    private String hash;
    private String nonce;
    private String blockHash;
    private String transactionIndex;
    private String from;
    private String to;

   
    public Data data;
    class Data{
     private String blockHash;
     private String transactionIndex;
     private String from;
     private String to;
    }
    
    
    public List<Price> Price;
    
    class Price{
     private String value;
     private String gas;
     private String gasPrice;
    }   

}
