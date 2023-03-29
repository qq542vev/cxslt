<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.rss20ToHtml.stylesheet"
	exclude-result-prefixes="cxsltl rdf xsl xsltdoc"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/date/common.xsl"/>
	<xsl:import href="../library/date/email.xsl"/>
	<xsl:import href="../library/basicMetaInformation.xsl"/>
	<xsl:import href="../library/rss20/basicMetaInformation.xsl"/>
	<xsl:import href="../library/template/html.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts RSS 2.0 format into XHTML format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">RSS 2.0 形式で書かれたファイルを XHTML+RDFa 1.0 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-12-05</xsltdoc:version>
		<xsltdoc:since>2011-03-22</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.rssboard.org/rss-specification"/>
		<xsltdoc:output rdf:resource="http://www.w3.org/TR/html51/"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:rss20ToHtml.self" select="document('')/xsl:stylesheet"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:rss20ToHtml.deny" select="/.."/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>RSS 2.0のデフォルト値</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:rss20ToHtml.defaultValue" select="$cxsltl:rss20.basicMetaInformation.defaultValue"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでのコールバックするテンプレート</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:rss20ToHtml.callback" select="$cxsltl:template.html.layout"/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のRSS 2.0の要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			HTMLへの変換はxsl:call-templateを使用しcxsltl:rss20ToHtml.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="HTMLを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:rss20ToHtml.convert">
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
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="RSS 2.0のデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:rss20ToHtml.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToHtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="defaultValue" select="$cxsltl:rss20ToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:rss20ToHtml.callback"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToHtml.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$callback"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:rss20ToHtml.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{channel}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="RSS 2.0のデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:returnNodeSet xsltdoc:short="HTMLを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="channel" mode="cxsltl:rss20ToHtml.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToHtml.deny"/>
		<xsl:param name="defaultValue" select="$cxsltl:rss20ToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:rss20ToHtml.callback"/>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="."/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$cxsltl:rss20ToHtml.self/xsl:template[@name = 'cxsltl:rss20ToHtml.get']"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{item}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{div}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="item" mode="cxsltl:rss20ToHtml.converter">
		<xsl:param name="deny" select="$cxsltl:rss20ToHtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:variable name="title">
			<xsl:apply-templates select="title" mode="cxsltl:rss20ToHtml.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:if test="not(title[count(. | $deny) != $denyCount])">No Title</xsl:if>
		</xsl:variable>

		<div class="cxsltl.rss20ToHtml.item">
			<h2 class="cxsltl.rss20ToHtml.title">
				<xsl:choose>
					<xsl:when test="link[count(. | $deny) != $denyCount]">
						<a href="{link}">
							<xsl:copy-of select="$title"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$title"/>
					</xsl:otherwise>
				</xsl:choose>
			</h2>

			<xsl:apply-templates select="description[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToHtml.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:if test="(author | category | comments | enclosure | guid | pubDate | source)[count(. | $deny) != $denyCount]">
				<dl>
					<xsl:apply-templates select="author[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToHtml.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
					</xsl:apply-templates>

					<xsl:apply-templates select="comments[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToHtml.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
					</xsl:apply-templates>

					<xsl:apply-templates select="enclosure[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToHtml.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
					</xsl:apply-templates>

					<xsl:apply-templates select="guid[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToHtml.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
					</xsl:apply-templates>

					<xsl:apply-templates select="pubDate[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToHtml.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
					</xsl:apply-templates>

					<xsl:apply-templates select="source[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToHtml.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
					</xsl:apply-templates>

					<xsl:if test="category[count(. | $deny) != $denyCount]">
						<dt>Category</dt>
						<dd>
							<xsl:apply-templates select="category[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToHtml.converter">
								<xsl:with-param name="deny" select="$deny"/>
								<xsl:with-param name="denyCount" select="$denyCount"/>
							</xsl:apply-templates>
						</dd>
					</xsl:if>
				</dl>
			</xsl:if>
		</div>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{author}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dt}要素、{dd}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="author" mode="cxsltl:rss20ToHtml.converter">
		<dt>Author</dt>
		<dd class="cxsltl.rss20ToHtml.author">
			<xsl:value-of select="normalize-space()"/>
		</dd>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{category}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{span}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="category" mode="cxsltl:rss20ToHtml.converter">
		<span class="cxsltl.rss20ToHtml.category">
			<xsl:value-of select="normalize-space()"/>
		</span>

		<xsl:if test="position() != last()">, </xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{comments}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dt}要素、{dd}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="comments" mode="cxsltl:rss20ToHtml.converter">
		<dt>Comments</dt>
		<dd class="cxsltl.rss20ToHtml.comments">
			<a href="{normalize-space()}">
				<xsl:value-of select="normalize-space()"/>
			</a>
		</dd>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{description}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{p}要素の値を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="description" mode="cxsltl:rss20ToHtml.converter">
		<p class="cxsltl.rss20ToHtml.description">
			<xsl:value-of disable-output-escaping="yes" select="."/>
		</p>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{enclosure}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dt}要素、{dd}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="enclosure" mode="cxsltl:rss20ToHtml.converter">
		<xsl:variable name="url" select="normalize-space(@url)"/>
		<xsl:variable name="type" select="normalize-space(@type)"/>
		<xsl:variable name="length" select="normalize-space(@length)"/>

		<dt>Enclosure</dt>
		<dd class="cxsltl.rss20ToHtml.enclosure">
			<a href="{$url}" type="{$type}">
				<xsl:attribute name="title">
					<xsl:value-of select="concat($type, ' file - ', $length, ' Bytes')"/>
				</xsl:attribute>

				<xsl:value-of select="$url"/>
			</a>
		</dd>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{guid}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dt}要素、{dd}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="guid" mode="cxsltl:rss20ToHtml.converter">
		<dt>Identifier</dt>
		<dd class="cxsltl.rss20ToHtml.guid">
			<xsl:choose>
				<xsl:when test="not(@isPermaLink) or normalize-space(@isPermaLink) = 'true'">
					<a href="{normalize-space()}">
						<xsl:value-of select="normalize-space()"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space()"/>
				</xsl:otherwise>
			</xsl:choose>
		</dd>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{pubDate}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dt}要素、{dd}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="pubDate" mode="cxsltl:rss20ToHtml.converter">
		<dt>Publication date</dt>
		<dd class="cxsltl.rss20ToHtml.pubDate">
			<xsl:call-template name="cxsltl:date.email.parse">
				<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toIso8601DateTime']"/>
			</xsl:call-template>
		</dd>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{source}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dt}要素、{dd}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="source" mode="cxsltl:rss20ToHtml.converter">
		<dt>Source</dt>
		<dd>
			<a href="{normalize-space(@url)}">
				<xsl:value-of select="normalize-space()"/>
			</a>
		</dd>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{title}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{title}要素の値を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="title" mode="cxsltl:rss20ToHtml.converter">
		<xsl:value-of select="normalize-space()"/>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 2.0をHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="RSS 2.0のデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:returnString xsltdoc:short="HTMLを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss20ToHtml.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:rss20ToHtml.deny"/>
		<xsl:param name="defaultValue" select="$cxsltl:rss20ToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:rss20ToHtml.callback"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:rss20ToHtml.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$callback"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ==============================
		# Callback xsl:template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>{$node}から{$type}の値を取得し{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="RSS 2.0のデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:paramString xsltdoc:name="type" xsltdoc:short="{$node}から取得する値のタイプ"/>
		<xsltdoc:returnNodeSet xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:rss20ToHtml.get']" mode="cxsltl:callback" name="cxsltl:rss20ToHtml.get">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:rss20ToHtml.deny"/>
		<xsl:param name="defaultValue" select="$cxsltl:rss20ToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>
		<xsl:param name="type">content</xsl:param>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:choose>
			<xsl:when test="$type = 'content'">
				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="node" select="$node/item[count(. | $deny) != $denyCount]"/>
					<xsl:with-param name="string">
						<div class="cxsltl.rss20ToHtml.content">
							<xsl:apply-templates select="$node/item" mode="cxsltl:rss20ToHtml.converter">
								<xsl:with-param name="deny" select="$deny"/>
								<xsl:with-param name="denyCount" select="$denyCount"/>
							</xsl:apply-templates>
						</div>
					</xsl:with-param>
					<xsl:with-param name="type">content</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="cxsltl:rss20.basicMetaInformation.get">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="defaultValue" select="$defaultValue"/>
					<xsl:with-param name="callback" select="$callback"/>
					<xsl:with-param name="type" select="$type"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>