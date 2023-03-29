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
		<xsltdoc:short>XMLを扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2016-01-03</xsltdoc:version>
		<xsltdoc:since>2014-12-23</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xml.parse.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>XMLの特殊文字をアンエスケープする置換用の要素</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:xml.parse.unescape" select="$cxsltl:xml.parse.self/cxsltl:string.search[@xml:id = 'cxsltl.xml.parse.unescape']/cxsltl:string.replace"/>

	<xsl:variable name="cxsltl:xml.parse.attributeNormalize" select="$cxsltl:xml.parse.self/cxsltl:string.search[@xml:id = 'cxsltl.xml.parse.attributeNormalize']/cxsltl:string.replace"/>

	<!-- ==============================
		# cxsltl:string.search Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.xml.parse.unescape">
		<xsltdoc:short>XMLの特殊文字をアンエスケープする置換用の要素</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:string.search xml:id="cxsltl.xml.parse.unescape">
		<cxsltl:string.replace src="&amp;lt;" dst="&lt;"/>
		<cxsltl:string.replace src="&amp;gt;" dst="&gt;"/>
		<cxsltl:string.replace src="&amp;quot;" dst="&quot;"/>
		<cxsltl:string.replace src="&amp;apos;" dst="&apos;"/>
		<cxsltl:string.replace src="&amp;amp;" dst="&amp;"/>
	</cxsltl:string.search>

	<cxsltl:string.search xml:id="cxsltl.xml.parse.attributeNormalize">
		<cxsltl:string.replace src="&#x9;" dst=" "/>
		<cxsltl:string.replace src="&#xA;" dst=" "/>
		<cxsltl:string.replace src="&#xD;" dst=" "/>
	</cxsltl:string.search>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsl:template name="cxsltl:xml.parse.attributeNormalize">
		<xsl:param name="string" select="."/>
		<xsl:param name="cdata" select="true()"/>

		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:string.multipleReplace">
				<xsl:with-param name="node" select="$cxsltl:xml.parse.attributeNormalize"/>
				<xsl:with-param name="string" select="$string"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$cdata">
				<xsl:value-of select="$result"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="cxsltl:string.bothTrim">
					<xsl:with-param name="string" select="$result"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>属性数を求める</xsltdoc:short>
		<xsltdoc:version>2015-02-11</xsltdoc:version>
		<xsltdoc:since>2014-12-23</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="attribute" xsltdoc:short="属性の文字列"/>
		<xsltdoc:return xsltdoc:short="属性数"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xml.parse.attributeCount">
		<xsl:param name="attribute" select="."/>
		<xsl:param name="_position" select="0"/>

		<xsl:variable name="singleQuotation">='</xsl:variable>
		<xsl:variable name="quotation" select="substring(substring-after($attribute, '='), 1, 1)"/>

		<xsl:choose>
			<xsl:when test="
				(contains($attribute, '=&quot;') or contains($attribute, $singleQuotation)) and
				contains(substring-after($attribute, $quotation), $quotation)
			">
				<xsl:call-template name="cxsltl:xml.parse.attributeCount">
					<xsl:with-param name="attribute" select="substring-after(substring-after($attribute, $quotation), $quotation)"/>
					<xsl:with-param name="_position" select="$_position + 1"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$_position"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>属性を分割し、$callbackにコールバックする</xsltdoc:short>
		<xsltdoc:version>2015-05-29</xsltdoc:version>
		<xsltdoc:since>2014-12-30</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="attribute" xsltdoc:short="疑似属性の文字列"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックを適用するノードセット"/>
		<xsltdoc:paramAny xsltdoc:name="param1" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param2" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param3" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param4" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:paramAny xsltdoc:name="param5" xsltdoc:short="任意のパラメータ"/>
		<xsltdoc:return xsltdoc:short="コールバックテンプレートから返ってきた値をそのまま返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xml.parse.attributeSplit">
		<xsl:param name="attribute" select="."/>
		<xsl:param name="callback" select="$cxsltl:xml.parse.self/xsl:template[@name = 'cxsltl:xml.parse.callback.attributeSplit']"/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>
		<xsl:param name="param4"/>
		<xsl:param name="param5"/>
		<xsl:param name="_count">
			<xsl:call-template name="cxsltl:xml.parse.attributeCount">
				<xsl:with-param name="atts" select="$attribute"/>
			</xsl:call-template>
		</xsl:param>
		<xsl:param name="_position" select="1"/>
		<xsl:param name="_original" select="$attribute"/>

		<xsl:variable name="singleQuotation">='</xsl:variable>
		<xsl:variable name="quotation" select="substring(substring-after($attribute, '='), 1, 1)"/>

		<xsl:if test="
			(contains($attribute, '=&quot;') or contains($attribute, $singleQuotation)) and
			contains(substring-after($attribute, $quotation), $quotation)
		">
			<xsl:apply-templates select="$callback" mode="cxsltl:callback">
				<xsl:with-param name="name" select="normalize-space(substring-before($attribute, '='))"/>
				<xsl:with-param name="value">
					<xsl:call-template name="cxsltl:xml.parse.unescape">
						<xsl:with-param name="string" select="normalize-space(substring-before(substring-after($attribute, $quotation), $quotation))"/>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="param1" select="$param1"/>
				<xsl:with-param name="param2" select="$param2"/>
				<xsl:with-param name="param3" select="$param3"/>
				<xsl:with-param name="param4" select="$param4"/>
				<xsl:with-param name="param5" select="$param5"/>
				<xsl:with-param name="count" select="number($_count)"/>
				<xsl:with-param name="position" select="number($_position)"/>
				<xsl:with-param name="original" select="$_original"/>
			</xsl:apply-templates>

			<xsl:call-template name="cxsltl:xml.parse.attributeSplit">
				<xsl:with-param name="attribute" select="substring-after(substring-after($attribute, $quotation), $quotation)"/>
				<xsl:with-param name="callback" select="$callback"/>
				<xsl:with-param name="param1" select="$param1"/>
				<xsl:with-param name="param2" select="$param2"/>
				<xsl:with-param name="param3" select="$param3"/>
				<xsl:with-param name="param4" select="$param4"/>
				<xsl:with-param name="param5" select="$param5"/>
				<xsl:with-param name="_count" select="$_count"/>
				<xsl:with-param name="_position" select="$_position + 1"/>
				<xsl:with-param name="_original" select="$_original"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:xml.parse.callback.attributeSplit']" mode="cxsltl:callback" name="cxsltl:xml.parse.callback.attributeSplit">
		<xsl:param name="name"/>
		<xsl:param name="value"/>

		<xsl:value-of select="concat($name, ' ' ,$value, '&#xA;')"/>
	</xsl:template>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>XMLの特殊文字をアンエスケープする</xsltdoc:short>
		<xsltdoc:example rdf:paserType="Resource">
			<xsltdoc:short><![CDATA[Return is <a href="http://www.w3.org/TR/xslt">XSLT 1.0</a>]]></xsltdoc:short>
			<rdf:value><![CDATA[
				<xsl:call-template name="cxsltl:xml.parse.unescape">
					<xsl:with-param name="string">&amp;lt;a href=&amp;quot;http://www.w3.org/TR/xslt&amp;quot;&amp;gt;XSLT 1.0&amp;lt;/a&amp;gt;</xsl:with-param>
				</xsl:call-template>
			]]></rdf:value>
		</xsltdoc:example>
		<xsltdoc:version>2015-01-11</xsltdoc:version>
		<xsltdoc:since>2014-12-28</xsltdoc:since>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="アンエスケープされる文字列"/>
		<xsltdoc:return xsltdoc:short="アンエスケープされた文字列"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:xml.parse.unescape">
		<xsl:param name="string" select="."/>

		<xsl:call-template name="cxsltl:string.multipleReplace">
			<xsl:with-param name="node" select="$cxsltl:xml.parse.unescape"/>
			<xsl:with-param name="string" select="$string"/>
		</xsl:call-template>
	</xsl:template>
</xsl:stylesheet>