package kr.co.shop.jsonparse.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.List;
import javax.servlet.http.HttpServletRequest;


import org.json.simple.JSONArray; 
import org.json.simple.JSONObject; 
import org.json.simple.parser.JSONParser; 
import org.json.simple.parser.ParseException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.shop.jsonparse.service.IndexService;
import kr.co.shop.jsonparse.vo.JsontestVO;
import kr.co.shop.jsonparse.vo.jsonVO;


@Controller
public class IndexController {

	@Autowired
	private IndexService indexService;

	@RequestMapping(value = "/jsontest")
	public String jsontest(Model model) {
		
		List<JsontestVO> jsontestList = indexService.getJsontestList();
		
		model.addAttribute("jsontestList", jsontestList);
		return "index/jsontest";
	}
	
	@RequestMapping(value = "/jsontest/save")
	public String jsontestSave(HttpServletRequest request, JsontestVO jsontestVO) {
		indexService.setJsontest(jsontestVO);
		return "redirect:/jsontest";
	}

	
	
	@RequestMapping(value = "/jsonparse")
	public String jsontesttest(Model model) throws IOException, ParseException {
	   Object jsonVO = new jsonVO();
		
		
		System.out.println("jsonparse:");	
	
		String urlStr = "https://ropsten.etherscan.io/api?module=account&action=txlist&address=0xFf0797D06e8F9897B1D5066C10D9497Ed7054A47&startblock=0&endblock=99999999&page=1&offset=1&sort=desc";
		URL url = new URL(urlStr);

		BufferedReader bf; String line = ""; 
		String resultdata=""; 

		bf = new BufferedReader(new InputStreamReader(url.openStream())); 

		 while((line=bf.readLine())!=null){
			resultdata=resultdata.concat(line);
		}
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObject = (JSONObject) jsonParser.parse(resultdata);
	  
		jsonVO =jsonObject.get("result");
		System.out.println("jsonVO11111         :"+  jsonVO);
	

		List<JsontestVO> jsontestList = indexService.getJsontestList();	
		model.addAttribute("jsontestList", jsontestList);		
		return "index/jsontest";
	}
	
}
