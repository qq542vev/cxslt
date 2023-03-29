<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../node/common.xsl"/>
	<xsl:import href="../string.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>XPathを扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-03-18</xsltdoc:version>
		<xsltdoc:since>2014-12-24</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="http://www.w3.org/TR/xpath/"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xpath.parse.self" select="document('')/xsl:stylesheet"/>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>XPathでノードにアクセスする</xsltdoc:short>
		<xsltdoc:version>2015-10-25</xsltdoc:version>
		<xsltdoc:since>2015-10-25</xsltdoc:since>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックを適用するノードセット"/>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="namespace" xsltdoc:short="XPathの名前空間"/>
		<xsltdoc:paramString xsltdoc:name="xpath" xsltdoc:short="xpath"/>
		<xsltdoc:paramAny xsltdoc:name="param1" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param2" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param3" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param4" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param5" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:return xsltdoc:short="コールバックテンプレートから返ってきた値をそのまま返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xpath.parse.acsess">
		<xsl:param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.map']"/>
		<xsl:param name="node" select="."/>
		<xsl:param name="namespace" select="namespace::*"/>
		<xsl:param name="xpath"/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>
		<xsl:param name="param4"/>
		<xsl:param name="param5"/>

		<xsl:choose>
			<xsl:when test="not($node and string($xpath))">
				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="param1" select="$param1"/>
					<xsl:with-param name="param2" select="$param2"/>
					<xsl:with-param name="param3" select="$param3"/>
					<xsl:with-param name="param4" select="$param4"/>
					<xsl:with-param name="param5" select="$param5"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="contains($xpath, '//')">
				<xsl:call-template name="cxsltl:xpath.parse.acsess">
					<xsl:with-param name="callback" select="$callback"/>
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="xpath">
						<xsl:call-template name="cxsltl:string.replace">
							<xsl:with-param name="string" select="$xpath"/>
							<xsl:with-param name="src">//</xsl:with-param>
							<xsl:with-param name="dst">/descendant-or-self::node()/</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
					<xsl:with-param name="namespace" select="$namespace"/>
					<xsl:with-param name="param1" select="$param1"/>
					<xsl:with-param name="param2" select="$param2"/>
					<xsl:with-param name="param3" select="$param3"/>
					<xsl:with-param name="param4" select="$param4"/>
					<xsl:with-param name="param5" select="$param5"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($xpath, '/')">
				<xsl:call-template name="cxsltl:xpath.parse.acsess">
					<xsl:with-param name="callback" select="$callback"/>
					<xsl:with-param name="node" select="$node/ancestor-or-self::node()[not(..)]"/>
					<xsl:with-param name="xpath" select="substring-after($xpath, '/')"/>
					<xsl:with-param name="namespace" select="$namespace"/>
					<xsl:with-param name="param1" select="$param1"/>
					<xsl:with-param name="param2" select="$param2"/>
					<xsl:with-param name="param3" select="$param3"/>
					<xsl:with-param name="param4" select="$param4"/>
					<xsl:with-param name="param5" select="$param5"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="step">
					<xsl:variable name="_step">
						<xsl:call-template name="cxsltl:string.substringBefore">
							<xsl:with-param name="string" select="$xpath"/>
							<xsl:with-param name="substring">/</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>

					<xsl:choose>
						<xsl:when test="contains($_step, '[') and substring($_step, string-length($_step), 1) != ']'">
							<xsl:call-template name="cxsltl:string.substringBefore">
								<xsl:with-param name="string" select="$xpath"/>
								<xsl:with-param name="substring">]/</xsl:with-param>
							</xsl:call-template>

							<xsl:text>]</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$_step"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="_axisSpecifierAndNodeTest">
					<xsl:call-template name="cxsltl:string.substringBefore">
						<xsl:with-param name="string" select="$step"/>
						<xsl:with-param name="substring">[</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="axisSpecifierAndNodeTest">
					<xsl:choose>
						<xsl:when test="starts-with($_axisSpecifierAndNodeTest, '..')">
							<xsl:value-of select="concat('parent::node()', substring-after($_axisSpecifierAndNodeTest, '..'))"/>
						</xsl:when>
						<xsl:when test="starts-with($_axisSpecifierAndNodeTest, '.')">
							<xsl:value-of select="concat('self::node()', substring-after($_axisSpecifierAndNodeTest, '.'))"/>
						</xsl:when>
						<xsl:when test="starts-with($_axisSpecifierAndNodeTest, '@')">
							<xsl:value-of select="concat('attribute::', substring-after($_axisSpecifierAndNodeTest, '@'))"/>
						</xsl:when>
						<xsl:when test="not(contains($_axisSpecifierAndNodeTest, '::'))">
							<xsl:value-of select="concat('child::', $_axisSpecifierAndNodeTest)"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$_axisSpecifierAndNodeTest"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="axis" select="substring-before($axisSpecifierAndNodeTest, '::')"/>
				<xsl:variable name="nodetest" select="substring-after($axisSpecifierAndNodeTest, '::')"/>

				<xsl:variable name="prefix" select="substring-before($nodetest, ':')"/>
				<xsl:variable name="namespaceUri" select="string($namespace[local-name() = $prefix])"/>
				<xsl:variable name="localName">
					<xsl:call-template name="cxsltl:string.substringAfter">
						<xsl:with-param name="string" select="$nodetest"/>
						<xsl:with-param name="substring">:</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="currentNode" select="
					(
						$node[$axis = 'ancestor']/ancestor::node() |
						$node[$axis = 'ancestor-or-self']/ancestor-or-self::node() |
						$node[$axis = 'attribute']/attribute::node() |
						$node[$axis = 'child']/child::node() |
						$node[$axis = 'descendant']/descendant::node() |
						$node[$axis = 'descendant-or-self']/descendant-or-self::node() |
						$node[$axis = 'following']/following::node() |
						$node[$axis = 'following-sibling']/following-sibling::node() |
						$node[$axis = 'namespace']/namespace::node() |
						$node[$axis = 'parent']/parent::node() |
						$node[$axis = 'preceding']/preceding::node() |
						$node[$axis = 'preceding-sibling']/preceding-sibling::node() |
						$node[$axis = 'self']
					)[
						$nodetest = 'node()' or
						(($axis = 'attribute' or $axis = 'namespace') and ($localName = '*' or local-name() = $localName) and (not($prefix) or namespace-uri() = $namespaceUri)) or
						($nodetest = 'text()' and self::text()) or
						($nodetest = 'comment()' and self::comment()) or
						($nodetest = 'processing-instruction()' and self::processing-instruction()) or
						(($localName = '*' or (local-name() = $localName and namespace-uri() = $namespaceUri)) and self::*)
					]
				"/>

				<xsl:variable name="filterNodeId">
					<xsl:call-template name="cxsltl:xpath.parse.predicate">
						<xsl:with-param name="node" select="$currentNode"/>
						<xsl:with-param name="predicate" select="substring-after($step, $_axisSpecifierAndNodeTest)"/>
						<xsl:with-param name="namespace" select="$namespace"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:call-template name="cxsltl:xpath.parse.acsess">
					<xsl:with-param name="callback" select="$callback"/>
					<xsl:with-param name="node" select="$currentNode[contains(concat(' ', $filterNodeId, ' '), concat(' ', generate-id(), ' '))]"/>
					<xsl:with-param name="xpath" select="substring-after($xpath, concat($step, '/'))"/>
					<xsl:with-param name="namespace" select="$namespace"/>
					<xsl:with-param name="param1" select="$param1"/>
					<xsl:with-param name="param2" select="$param2"/>
					<xsl:with-param name="param3" select="$param3"/>
					<xsl:with-param name="param4" select="$param4"/>
					<xsl:with-param name="param5" select="$param5"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="cxsltl:xpath.parse.predicate">
		<xsl:param name="callback" select="$cxsltl:node.common.self/xsl:template[@name = 'cxsltl:node.common.map']"/>
		<xsl:param name="node" select="."/>
		<xsl:param name="namespace" select="namespace::*"/>
		<xsl:param name="predicate"/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>
		<xsl:param name="param4"/>
		<xsl:param name="param5"/>

		<xsl:choose>
			<xsl:when test="not($node and string($predicate))">
				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="param1" select="$param1"/>
					<xsl:with-param name="param2" select="$param2"/>
					<xsl:with-param name="param3" select="$param3"/>
					<xsl:with-param name="param4" select="$param4"/>
					<xsl:with-param name="param5" select="$param5"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="filter" select="substring-before(substring-after($predicate, '['), ']')"/>

				<xsl:variable name="filterNodeId">
					<xsl:if test="string(number($filter)) = 'NaN' and $filter != 'last()'">
						<xsl:text> </xsl:text>

						<xsl:for-each select="$node">
							<xsl:variable name="nodeId">
								<xsl:call-template name="cxsltl:xpath.parse.acsess">
									<xsl:with-param name="xpath" select="$filter"/>
									<xsl:with-param name="namespace" select="$namespace"/>
								</xsl:call-template>
							</xsl:variable>

							<xsl:if test="string($nodeId)">
								<xsl:value-of select="concat(generate-id(), ' ')"/>
							</xsl:if>
						</xsl:for-each>
					</xsl:if>
				</xsl:variable>

				<xsl:call-template name="cxsltl:xpath.parse.predicate">
					<xsl:with-param name="callback" select="$callback"/>
					<xsl:with-param name="node" select="$node[
						(string(number($filter)) = 'NaN' or position() = $filter) and
						($filter != 'last()' or position() = last()) and
						(not(string($filterNodeId)) or contains($filterNodeId, concat(' ', generate-id(), ' ')))
					]"/>
					<xsl:with-param name="predicate" select="substring-after($predicate, ']')"/>
					<xsl:with-param name="namespace" select="$namespace"/>
					<xsl:with-param name="param1" select="$param1"/>
					<xsl:with-param name="param2" select="$param2"/>
					<xsl:with-param name="param3" select="$param3"/>
					<xsl:with-param name="param4" select="$param4"/>
					<xsl:with-param name="param5" select="$param5"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>