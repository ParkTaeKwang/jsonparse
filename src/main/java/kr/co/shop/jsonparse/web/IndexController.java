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
	public String jsontesttest(Model model) throws IOException {		
		System.out.println("jsonparse:");	
	
		String urlStr = "https://api.etherscan.io/api?module=account&action=tokentx&contractaddress=0xB8c77482e45F1F44dE1745F52C74426C631bDD52&page=1&offset=1&sort=desc";
		URL url = new URL(urlStr);

		BufferedReader bf; String line = ""; 
		String result=""; 

		bf = new BufferedReader(new InputStreamReader(url.openStream())); 

		 while((line=bf.readLine())!=null){
			result=result.concat(line); // System.out.println(result); 
		}
		/*
		Object jsoninfo = new jsonVO();					
		JSONParser jsonParser = new JSONParser();		
		JSONObject jsonObject = (JSONObject) jsonParser
		jsoninfo =  jsonObject.get("resultJSON");
		  */
		
		System.out.println("result          :"+  result);

		List<JsontestVO> jsontestList = indexService.getJsontestList();
		
		model.addAttribute("jsontestList", jsontestList);
		
		return "index/jsontest";
	}
	
}
