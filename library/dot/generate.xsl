<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../string.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>DOTを扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-06-22</xsltdoc:version>
		<xsltdoc:since>2017-06-22</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="http://www.graphviz.org/Documentation.php"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:dot.generate.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>特殊文字をバックスラッシュでエスケープする置換用の要素</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:dot.generate.escape" select="$cxsltl:dot.generate.self/cxsltl:string.search[@xml:id = 'cxsltl.dot.generate.escape']/cxsltl:string.replace"/>

	<!-- ==============================
		# cxsltl:string.search Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.dot.generate.escape">
		<xsltdoc:short>特殊文字をバックスラッシュでエスケープする置換用の要素</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:string.search xml:id="cxsltl.dot.generate.escape">
		<cxsltl:string.replace src="\" dst="\\"/>
		<cxsltl:string.replace src="&quot;" dst="\&quot;"/>
		<cxsltl:string.replace src="&#xD;&#xA;" dst="\n"/>
		<cxsltl:string.replace src="&#xA;" dst="\n"/>
		<cxsltl:string.replace src="&#xD;" dst="\n"/>
	</cxsltl:string.search>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>属性を生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="属性名"/>
		<xsltdoc:paramString xsltdoc:name="value" xsltdoc:short="属性値"/>
		<xsltdoc:paramString xsltdoc:name="name1" xsltdoc:short="属性名 1"/>
		<xsltdoc:paramString xsltdoc:name="value1" xsltdoc:short="属性値 1"/>
		<xsltdoc:paramString xsltdoc:name="name2" xsltdoc:short="属性名 2"/>
		<xsltdoc:paramString xsltdoc:name="value2" xsltdoc:short="属性値 2"/>
		<xsltdoc:paramString xsltdoc:name="name3" xsltdoc:short="属性名 3"/>
		<xsltdoc:paramString xsltdoc:name="value3" xsltdoc:short="属性値 3"/>
		<xsltdoc:paramString xsltdoc:name="name4" xsltdoc:short="属性名 4"/>
		<xsltdoc:paramString xsltdoc:name="value4" xsltdoc:short="属性値 4"/>
		<xsltdoc:paramBoolean xsltdoc:name="last" xsltdoc:short="最後の属性の後ろに$delimiterを生成するか"/>
		<xsltdoc:paramString xsltdoc:name="delimiter" xsltdoc:short="区切り文字"/>
		<xsltdoc:returnString xsltdoc:short="属性を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:dot.generate.attribute">
		<xsl:param name="name" select="name()"/>
		<xsl:param name="value" select="."/>
		<xsl:param name="name1"/>
		<xsl:param name="value1"/>
		<xsl:param name="name2"/>
		<xsl:param name="value2"/>
		<xsl:param name="name3"/>
		<xsl:param name="value3"/>
		<xsl:param name="name4"/>
		<xsl:param name="value4"/>
		<xsl:param name="last" select="false()"/>
		<xsl:param name="delimiter">, </xsl:param>

		<xsl:value-of select="$name"/>

		<xsl:text>=</xsl:text>

		<xsl:call-template name="cxsltl:dot.generate.escape">
			<xsl:with-param name="string" select="$value"/>
		</xsl:call-template>

		<xsl:choose>
			<xsl:when test="string($name1)">
				<xsl:value-of select="$delimiter"/>

				<xsl:call-template name="cxsltl:dot.generate.attribute">
					<xsl:with-param name="name" select="$name1"/>
					<xsl:with-param name="value" select="$value1"/>
					<xsl:with-param name="name1" select="$name2"/>
					<xsl:with-param name="value1" select="$value2"/>
					<xsl:with-param name="name2" select="$name3"/>
					<xsl:with-param name="value2" select="$value3"/>
					<xsl:with-param name="name3" select="$name4"/>
					<xsl:with-param name="value3" select="$value4"/>
					<xsl:with-param name="last" select="$last"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($last)">
				<xsl:value-of select="$delimiter"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>特殊文字をバックスラッシュでエスケープする</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="文字列"/>
		<xsltdoc:returnString xsltdoc:short="エスケープした文字列を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:dot.generate.escape">
		<xsl:param name="string" select="."/>

		<xsl:text>"</xsl:text>

		<xsl:call-template name="cxsltl:string.multipleReplace">
			<xsl:with-param name="node" select="$cxsltl:dot.generate.escape"/>
			<xsl:with-param name="string" select="$string"/>
		</xsl:call-template>

		<xsl:text>"</xsl:text>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>グラフを生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="name" xsltdoc:short="グラフ名"/>
		<xsltdoc:paramString xsltdoc:name="graph" xsltdoc:short="グラフのタイプ"/>
		<xsltdoc:paramString xsltdoc:name="content" xsltdoc:short="グラフ内容"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="グラフの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="インデントの文字列"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="改行文字"/>
		<xsltdoc:returnString xsltdoc:short="グラフを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:dot.generate.graph">
		<xsl:param name="name">Graph</xsl:param>
		<xsl:param name="graph">graph</xsl:param>
		<xsl:param name="content" select="."/>
		<xsl:param name="depth" select="0"/>
		<xsl:param name="indent" select="'&#x9;'"/>
		<xsl:param name="eol" select="'&#xA;'"/>

		<xsl:variable name="whitespace">
			<xsl:call-template name="cxsltl:string.repeat">
				<xsl:with-param name="string" select="$indent"/>
				<xsl:with-param name="multiplier" select="$depth"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:value-of select="concat($whitespace, $graph, ' ', $name)"/>

		<xsl:if test="string($indent)">
			<xsl:text> </xsl:text>
		</xsl:if>

		<xsl:text>{</xsl:text>

		<xsl:if test="string($content)">
			<xsl:value-of select="$eol"/>
		</xsl:if>

		<xsl:value-of select="concat($content, $whitespace, '}')"/>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>ノードを生成する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="node" xsltdoc:short="ノード"/>
		<xsltdoc:paramString xsltdoc:name="node1" xsltdoc:short="ノード 1"/>
		<xsltdoc:paramString xsltdoc:name="node2" xsltdoc:short="ノード 2"/>
		<xsltdoc:paramString xsltdoc:name="node3" xsltdoc:short="ノード 3"/>
		<xsltdoc:paramString xsltdoc:name="node4" xsltdoc:short="ノード 4"/>
		<xsltdoc:paramBoolean xsltdoc:name="nodeEscape" xsltdoc:short="ノードをエスケープするか"/>
		<xsltdoc:paramBoolean xsltdoc:name="graph" xsltdoc:short="無向グラフか"/>
		<xsltdoc:paramString xsltdoc:name="attribute" xsltdoc:short="属性"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="グラフの深さ"/>
		<xsltdoc:paramString xsltdoc:name="indent" xsltdoc:short="インデントの文字列"/>
		<xsltdoc:paramString xsltdoc:name="eol" xsltdoc:short="改行文字"/>
		<xsltdoc:returnString xsltdoc:short="ノードを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:dot.generate.node">
		<xsl:param name="node" select="."/>
		<xsl:param name="node1"/>
		<xsl:param name="node2"/>
		<xsl:param name="node3"/>
		<xsl:param name="node4"/>
		<xsl:param name="nodeEscape" select="true()"/>
		<xsl:param name="graph" select="true()"/>
		<xsl:param name="attribute"/>
		<xsl:param name="depth" select="1"/>
		<xsl:param name="indent" select="'&#x9;'"/>
		<xsl:param name="eol" select="'&#xA;'"/>

		<xsl:variable name="whitespace">
			<xsl:if test="string($indent)">
				<xsl:text> </xsl:text>
			</xsl:if>
		</xsl:variable>

		<xsl:call-template name="cxsltl:string.repeat">
			<xsl:with-param name="string" select="$indent"/>
			<xsl:with-param name="multiplier" select="$depth"/>
		</xsl:call-template>

		<xsl:choose>
			<xsl:when test="$node = 'graph' or $node = 'node' or $node = 'edge' or not($nodeEscape)">
				<xsl:value-of select="$node"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="cxsltl:dot.generate.escape">
					<xsl:with-param name="string" select="$node"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:choose>
			<xsl:when test="string($node1)">
				<xsl:value-of select="$whitespace"/>

				<xsl:choose>
					<xsl:when test="$graph">--</xsl:when>
					<xsl:otherwise>-&gt;</xsl:otherwise>
				</xsl:choose>

				<xsl:call-template name="cxsltl:dot.generate.node">
					<xsl:with-param name="node" select="$node1"/>
					<xsl:with-param name="node1" select="$node2"/>
					<xsl:with-param name="node2" select="$node3"/>
					<xsl:with-param name="node3" select="$node4"/>
					<xsl:with-param name="nodeEscape" select="$nodeEscape"/>
					<xsl:with-param name="graph" select="$graph"/>
					<xsl:with-param name="attribute" select="$attribute"/>
					<xsl:with-param name="indent" select="$whitespace"/>
					<xsl:with-param name="eol" select="$eol"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="string($attribute)">
					<xsl:value-of select="concat($whitespace, '[')"/>

					<xsl:call-template name="cxsltl:dot.generate.trim">
						<xsl:with-param name="string" select="$attribute"/>
					</xsl:call-template>

					<xsl:text>]</xsl:text>
				</xsl:if>

				<xsl:value-of select="concat(';', $eol)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>文字列の文頭と文末から空白とカンマを取り除く</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="文字列"/>
		<xsltdoc:paramString xsltdoc:name="charlist" xsltdoc:short="取り除く文字"/>
		<xsltdoc:returnString xsltdoc:short="文頭と文末を処理した文字列を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:dot.generate.trim">
		<xsl:param name="string" select="."/>
		<xsl:param name="charlist" select="'&#x9;&#xA;&#xD; ,'"/>

		<xsl:call-template name="cxsltl:string.bothTrim">
			<xsl:with-param name="string" select="$string"/>
			<xsl:with-param name="charlist" select="$charlist"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>