<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.rss20ToRss30.stylesheet"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/date/common.xsl"/>
	<xsl:import href="../library/date/email.xsl"/>
	<xsl:import href="../library/rss20/get.xsl"/>
	<xsl:import href="../library/rss30/generate.xsl"/>
	<xsl:import href="../library/xml/generate.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts RSS 2.0 format into RSS 3.0 format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">RSS 2.0 形式で書かれたファイルを RSS 3.0 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-09-18</xsltdoc:version>
		<xsltdoc:since>2011-10-16</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.rssboard.org/rss-specification"/>
		<xsltdoc:output rdf:resource="http://www.aaronsw.com/2002/rss30"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="text" encoding="UTF-8" media-type="text/plain"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:rss20ToRss30.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のRSS 2.0の要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			RSS 3.0への変換はxsl:call-templateを使用しcxsltl:rss20ToRss30.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:rss20ToRss30.convert">
			<xsl:with-param name="node" select="rss/channel"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		## xsl:template for RSS 2.0 element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:rss20ToRss30.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss30.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:rss20ToRss30.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{channel}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="channel" mode="cxsltl:rss20ToRss30.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss30.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="*[not(self::item)][count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="item[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{item}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のitemを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item" mode="cxsltl:rss20ToRss30.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToRss30.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:text>&#xA;</xsl:text>

		<xsl:apply-templates select="*[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0の行を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="title | link | channel/description | generator | language" mode="cxsltl:rss20ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{author}要素と{managingEditor}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のcreatorを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="author | managingEditor" mode="cxsltl:rss20ToRss30.converter">
		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:rss20.get.email"/>
		</xsl:variable>
		<xsl:variable name="email" select="substring-before($result, ' ')"/>
		<xsl:variable name="name" select="substring-after($result, ' ')"/>

		<xsl:if test="$email">
			<xsl:call-template name="cxsltl:rss30.generate.agent">
				<xsl:with-param name="tokenName">creator</xsl:with-param>
				<xsl:with-param name="email" select="$email"/>
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{category}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のsubjectを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="category" mode="cxsltl:rss20ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">subject</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{copyright}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のrightsを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="copyright" mode="cxsltl:rss20ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">rights</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{description}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のdescriptionを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item/description" mode="cxsltl:rss20ToRss30.converter">
		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:xml.generate.removeTags"/>
		</xsl:variable>

		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="value" select="normalize-space($result)"/>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{guid}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のguidを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="guid" mode="cxsltl:rss20ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">guid</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{guid[not(@isPermaLink) or @isPermaLink = 'true']}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のuriを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="guid[not(@isPermaLink) or @isPermaLink = 'true']" mode="cxsltl:rss20ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">uri</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{lastBuildDate}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のlast-modifiedを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="lastBuildDate" mode="cxsltl:rss20ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">last-modified</xsl:with-param>
			<xsl:with-param name="value">
				<xsl:call-template name="cxsltl:date.email.parse">
					<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toIso8601DateTime']"/>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{pubDate}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のcreatedを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="pubDate" mode="cxsltl:rss20ToRss30.converter">
		<xsl:call-template name="cxsltl:rss30.generate.line">
			<xsl:with-param name="name">created</xsl:with-param>
			<xsl:with-param name="value">
				<xsl:call-template name="cxsltl:date.email.parse">
					<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toIso8601DateTime']"/>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{webMaster}要素をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0のerrorstoを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="webMaster" mode="cxsltl:rss20ToRss30.converter">
		<xsl:variable name="result">
			<xsl:call-template name="cxsltl:rss20.get.email"/>
		</xsl:variable>
		<xsl:variable name="email" select="substring-before($result, ' ')"/>
		<xsl:variable name="name" select="substring-after($result, ' ')"/>

		<xsl:if test="$email">
			<xsl:call-template name="cxsltl:rss30.generate.agent">
				<xsl:with-param name="tokenName">errorsto</xsl:with-param>
				<xsl:with-param name="email" select="$email"/>
				<xsl:with-param name="name" select="$name"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 2.0をRSS 3.0に変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnString xsltdoc:short="RSS 3.0を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss20ToRss30.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:rss20ToRss30.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToRss30.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>