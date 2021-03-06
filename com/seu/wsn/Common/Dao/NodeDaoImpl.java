package com.seu.wsn.Common.Dao;

import java.util.List;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.support.SqlSessionDaoSupport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.seu.wsn.Core.Pojo.Node;
/**
 * 
 * @ClassName: NodeDaoImpl 
 * @Description: 节点数据访问层实现类
 * @author: CSS
 * @date: 2016-11-3 上午10:00:35
 */
@Repository("nodeDao")
public class NodeDaoImpl extends SqlSessionDaoSupport implements NodeDao{
	/*
	 * (non Javadoc) 
	 * @Title: setSqlSessionFactory
	 * @Description: 注入SqlSessionFactory
	 * @param sqlSessionFactory 
	 * @see org.mybatis.spring.support.SqlSessionDaoSupport#setSqlSessionFactory(org.apache.ibatis.session.SqlSessionFactory)
	 */
	@Autowired
	@Override
	public void setSqlSessionFactory(SqlSessionFactory sqlSessionFactory) {
		super.setSqlSessionFactory(sqlSessionFactory);
	}

	/*
	 * (non Javadoc) 
	 * @Title: insert
	 * @Description: 插入新节点
	 * @param node 
	 * @see com.seu.wsn.Common.Dao.NodeDao#insert(com.seu.wsn.Core.Pojo.Node)
	 */
	@Override
	public void insert(Node node) {
		getSqlSession().insert("com.seu.wsn.node.mapper.insertNode", node);
		
	}
	/*
	 * (non Javadoc) 
	 * @Title: update
	 * @Description: 更新节点信息
	 * @param node 
	 * @see com.seu.wsn.Common.Dao.NodeDao#update(com.seu.wsn.Core.Pojo.Node)
	 */
	@Override
	public void update(Node node) {
		getSqlSession().update("com.seu.wsn.node.mapper.updateNode", node);
	}
	/*
	 * (non Javadoc) 
	 * @Title: nodeList
	 * @Description: 获取节点列表
	 * @return 
	 * @see com.seu.wsn.Common.Dao.NodeDao#nodeList()
	 */
	@Override
	public List<Node> nodeList() {
		return getSqlSession().selectList("com.seu.wsn.node.mapper.nodeList");
	}
	/*
	 * (non Javadoc) 
	 * @Title: getNodeListByTestId
	 * @Description: 根据测试编号获取满足条件的节点列表
	 * @param testId
	 * @return 
	 * @see com.seu.wsn.Common.Dao.NodeDao#getNodeListByTestId(java.lang.String)
	 */
	@Override
	public List<Node> getNodeListByTestId(String testId) {
		return getSqlSession().selectList("com.seu.wsn.node.mapper.nodeListByTestId",testId);
	}
	/*
	 * (non Javadoc) 
	 * @Title: select
	 * @Description: 根据条件选择节点
	 * @param node
	 * @return 
	 * @see com.seu.wsn.Common.Dao.NodeDao#select(com.seu.wsn.Core.Pojo.Node)
	 */
	@Override
	public Node select(Node node) {
		// TODO Auto-generated method stub
		return getSqlSession().selectOne("com.seu.wsn.node.mapper.selectNode", node);
	}
	@Override
	public Node selectByIp(Node node) {
		// TODO Auto-generated method stub
		return getSqlSession().selectOne("com.seu.wsn.node.mapper.selectNodeByIp", node);
	}
	/*
	 * (non Javadoc) 
	 * @Title: getNodeListByNodeType
	 * @Description: 根据节点类型获取满足条件的节点列表
	 * @param node
	 * @return 
	 * @see com.seu.wsn.Common.Dao.NodeDao#getNodeListByNodeType(com.seu.wsn.Core.Pojo.Node)
	 */
	@Override
	public List<Node> getNodeListByNodeType(Node node) {
		// TODO Auto-generated method stub
		return getSqlSession().selectList("com.seu.wsn.node.mapper.selectNodeByType",node);
	}

}
