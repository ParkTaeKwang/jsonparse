package kr.co.shop.jsonparse.web;

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
	public String jsontesttest(Model model) {		
		System.out.println("jsonparse:");	
	
		String apiUrl = "https://api.etherscan.io/api?module=account&action=tokentx&contractaddress=0xB8c77482e45F1F44dE1745F52C74426C631bDD52&page=1&offset=1&sort=desc";
		StringBuilder urlBuilder = new StringBuilder(apiUrl);
		URL url = null;
		try {
			url = new URL(urlBuilder.toString());
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		/*
		Object jsoninfo = new jsonVO();					
		JSONParser jsonParser = new JSONParser();		
		JSONObject jsonObject = (JSONObject) jsonParser
		jsoninfo =  jsonObject.get("resultJSON");
		  */
		
		System.out.println("url          :"+  url);

		List<JsontestVO> jsontestList = indexService.getJsontestList();
		
		model.addAttribute("jsontestList", jsontestList);
		
		return "index/jsontest";
	}
	
}
