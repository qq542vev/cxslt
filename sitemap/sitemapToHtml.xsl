<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.sitemapToHtml.stylesheet"
	exclude-result-prefixes="cxsltl rdf sitemap xsl xsltdoc"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:sitemap="http://www.sitemaps.org/schemas/sitemap/0.9"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/basicMetaInformation.xsl"/>
	<xsl:import href="../library/sitemap/basicMetaInformation.xsl"/>
	<xsl:import href="../library/template/html.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT which converts Sitemap 0.9 into HTML</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">Sitemap 0.9 形式で書かれたファイルを HTML 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-10-20</xsltdoc:version>
		<xsltdoc:since>2011-03-22</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="https://www.sitemaps.org/protocol.html"/>
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

	<xsl:variable name="cxsltl:sitemapToHtml.self" select="document('')/xsl:stylesheet"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:sitemapToHtml.deny" select="/.."/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>Sitemapのデフォルト値</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:sitemapToHtml.defaultValue" select="$cxsltl:sitemap.basicMetaInformation.defaultValue"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでのコールバックするテンプレート</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:sitemapToHtml.callback" select="$cxsltl:template.html.layout"/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のSitemapの要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			HTMLへの変換はxsl:call-templateを使用しcxsltl:sitemapToHtml.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="HTMLを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:sitemapToHtml.convert">
			<xsl:with-param name="node" select="sitemap:urlset"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		## xsl:template for Sitemap element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="Sitemapのデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:sitemapToHtml.converter">
		<xsl:param name="deny" select="$cxsltl:sitemapToHtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="defaultValue" select="$cxsltl:sitemapToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:sitemapToHtml.callback"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:sitemapToHtml.converter">
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

	<xsl:template match="text() | @*" mode="cxsltl:sitemapToHtml.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{sitemap:urlset}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="Sitemapのデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:returnNodeSet xsltdoc:short="HTMLを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="sitemap:urlset" mode="cxsltl:sitemapToHtml.converter">
		<xsl:param name="deny" select="$cxsltl:sitemapToHtml.deny"/>
		<xsl:param name="defaultValue" select="$cxsltl:sitemapToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:sitemapToHtml.callback"/>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="."/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$cxsltl:sitemapToHtml.self/xsl:template[@name = 'cxsltl:sitemapToHtml.get']"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{sitemap:url}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{tr}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="sitemap:url" mode="cxsltl:sitemapToHtml.converter">
		<xsl:param name="deny" select="$cxsltl:sitemapToHtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="lastmod" select="sitemap:lastmod"/>
		<xsl:param name="changefreq" select="sitemap:changefreq"/>
		<xsl:param name="priority" select="sitemap:priority"/>

		<tr class="cxsltl.sitemapToHtml.sitemap.url">
			<xsl:apply-templates select="sitemap:loc[count(. | $deny) != $denyCount]" mode="cxsltl:sitemapToHtml.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:if test="$lastmod">
				<xsl:apply-templates select="sitemap:lastmod[count(. | $deny) != $denyCount]" mode="cxsltl:sitemapToHtml.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</xsl:if>

			<xsl:if test="$changefreq">
				<xsl:apply-templates select="sitemap:changefreq[count(. | $deny) != $denyCount]" mode="cxsltl:sitemapToHtml.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</xsl:if>

			<xsl:if test="$priority">
				<xsl:apply-templates select="sitemap:priority[count(. | $deny) != $denyCount]" mode="cxsltl:sitemapToHtml.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</xsl:if>
		</tr>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{sitemap:loc}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{a}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="sitemap:loc" mode="cxsltl:sitemapToHtml.converter">
		<td class="cxsltl.sitemapToHtml.sitemap.loc">
			<a href="{normalize-space()}">
				<xsl:value-of select="normalize-space()"/>
			</a>
		</td>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{sitemap:*}要素をHTMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{td}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="sitemap:lastmod | sitemap:changefreq | sitemap:priority" mode="cxsltl:sitemapToHtml.converter">
		<td class="cxsltl.sitemapToHtml.sitemap.{local-name()}">
			<xsl:value-of select="normalize-space()"/>
		</td>
	</xsl:template>

	<!-- ==============================
		## xsl:template for URL Table
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>URLテーブルのテンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:sitemapToHtml.urlTable"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{sitemap:urlset}を表にする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{div}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="sitemap:urlset" mode="cxsltl:sitemapToHtml.urlTable">
		<xsl:param name="deny" select="$cxsltl:sitemapToHtml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:variable name="url" select="sitemap:url[count(. | $deny) != $denyCount]"/>
		<xsl:variable name="lastmod" select="$url/sitemap:lastmod[count(. | $deny) != $denyCount]"/>
		<xsl:variable name="changefreq" select="$url/sitemap:changefreq[count(. | $deny) != $denyCount]"/>
		<xsl:variable name="priority" select="$url/sitemap:priority[count(. | $deny) != $denyCount]"/>

		<div class="cxsltl.sitemapToHtml.content">
			<table>
				<thead>
					<tr>
						<th>loc</th>

						<xsl:if test="$lastmod">
							<th>lastmod</th>
						</xsl:if>

						<xsl:if test="$changefreq">
							<th>changefreq</th>
						</xsl:if>

						<xsl:if test="$priority">
							<th>priority</th>
						</xsl:if>
					</tr>
				</thead>
				<tbody class="cxsltl.sitemapToHtml.sitemap.urlset">
					<xsl:apply-templates select="$url" mode="cxsltl:sitemapToHtml.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
						<xsl:with-param name="lastmod" select="$lastmod"/>
						<xsl:with-param name="changefreq" select="$changefreq"/>
						<xsl:with-param name="priority" select="$priority"/>
					</xsl:apply-templates>
				</tbody>
			</table>
		</div>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>SitemapをHTMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="Sitemapのデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:returnNodeSet xsltdoc:short="HTMLを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:sitemapToHtml.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:sitemapToHtml.deny"/>
		<xsl:param name="defaultValue" select="$cxsltl:sitemapToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:sitemapToHtml.callback"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:sitemapToHtml.converter">
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
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="Sitemapのデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:paramString xsltdoc:name="type" xsltdoc:short="{$node}から取得する値のタイプ"/>
		<xsltdoc:returnNodeSet xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:sitemapToHtml.get']" mode="cxsltl:callback" name="cxsltl:sitemapToHtml.get">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:sitemapToHtml.deny"/>
		<xsl:param name="defaultValue" select="$cxsltl:sitemapToHtml.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>
		<xsl:param name="type">content</xsl:param>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:choose>
			<xsl:when test="$type = 'content'">
				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="node" select="$node/sitemap:url[count(. | $deny) != $denyCount]"/>
					<xsl:with-param name="string">
						<xsl:apply-templates select="$node" mode="cxsltl:sitemapToHtml.urlTable">
							<xsl:with-param name="deny" select="$deny"/>
							<xsl:with-param name="denyCount" select="$denyCount"/>
						</xsl:apply-templates>
					</xsl:with-param>
					<xsl:with-param name="type">content</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="cxsltl:sitemap.basicMetaInformation.get">
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