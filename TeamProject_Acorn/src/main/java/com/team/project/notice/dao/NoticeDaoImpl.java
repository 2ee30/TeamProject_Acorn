package com.team.project.notice.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.team.project.notice.dto.NoticeDto;

@Repository
public class NoticeDaoImpl implements NoticeDao{
	@Autowired
	private SqlSession session;

	@Override
	public int getCount(NoticeDto dto) {
		// 검색 조건에 맞는 파일의 전체 갯수를 select 해서
		int count=session.selectOne("notice.getCount", dto);
				// 리턴한다.
		return count;
	}

	@Override
	public List<NoticeDto> getList(NoticeDto dto) {
		List<NoticeDto> list=session.selectList("notice.getList", dto);
		return list;
	}

}