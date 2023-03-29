<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="string.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>URLを扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-09-15</xsltdoc:version>
		<xsltdoc:since>2017-09-06</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="https://www.ietf.org/rfc/rfc3986.txt"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:uri.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>パーセントエンコーディングの正規化ための置換用の要素</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:uri.percentDecode" select="$cxsltl:uri.self/cxsltl:string.search[@xml:id = 'cxsltl.uri.percentDecode']/cxsltl:string.replace"/>

	<!-- ==============================
		# cxsltl:string.search Element
	 ============================== -->

	<xsltdoc:Element rdf:about="#cxsltl.uri.percentDecode">
		<xsltdoc:short>パーセントエンコーディングの正規化ための置換用の要素</xsltdoc:short>
		<xsltdoc:private/>
	</xsltdoc:Element>

	<cxsltl:string.search xml:id="cxsltl.uri.percentDecode">
		<cxsltl:string.replace src="%41" dst="A"/>
		<cxsltl:string.replace src="%42" dst="B"/>
		<cxsltl:string.replace src="%43" dst="C"/>
		<cxsltl:string.replace src="%44" dst="D"/>
		<cxsltl:string.replace src="%45" dst="E"/>
		<cxsltl:string.replace src="%46" dst="F"/>
		<cxsltl:string.replace src="%47" dst="G"/>
		<cxsltl:string.replace src="%48" dst="H"/>
		<cxsltl:string.replace src="%49" dst="I"/>
		<cxsltl:string.replace src="%4A" dst="J"/>
		<cxsltl:string.replace src="%4B" dst="K"/>
		<cxsltl:string.replace src="%4C" dst="L"/>
		<cxsltl:string.replace src="%4D" dst="M"/>
		<cxsltl:string.replace src="%4E" dst="N"/>
		<cxsltl:string.replace src="%4F" dst="O"/>
		<cxsltl:string.replace src="%50" dst="P"/>
		<cxsltl:string.replace src="%51" dst="Q"/>
		<cxsltl:string.replace src="%52" dst="R"/>
		<cxsltl:string.replace src="%53" dst="S"/>
		<cxsltl:string.replace src="%54" dst="T"/>
		<cxsltl:string.replace src="%55" dst="U"/>
		<cxsltl:string.replace src="%56" dst="V"/>
		<cxsltl:string.replace src="%57" dst="W"/>
		<cxsltl:string.replace src="%58" dst="X"/>
		<cxsltl:string.replace src="%59" dst="Y"/>
		<cxsltl:string.replace src="%5A" dst="Z"/>
		<cxsltl:string.replace src="%61" dst="a"/>
		<cxsltl:string.replace src="%62" dst="b"/>
		<cxsltl:string.replace src="%63" dst="c"/>
		<cxsltl:string.replace src="%64" dst="d"/>
		<cxsltl:string.replace src="%65" dst="e"/>
		<cxsltl:string.replace src="%66" dst="f"/>
		<cxsltl:string.replace src="%67" dst="g"/>
		<cxsltl:string.replace src="%68" dst="h"/>
		<cxsltl:string.replace src="%69" dst="i"/>
		<cxsltl:string.replace src="%6A" dst="j"/>
		<cxsltl:string.replace src="%6B" dst="k"/>
		<cxsltl:string.replace src="%6C" dst="l"/>
		<cxsltl:string.replace src="%6D" dst="m"/>
		<cxsltl:string.replace src="%6E" dst="n"/>
		<cxsltl:string.replace src="%6F" dst="o"/>
		<cxsltl:string.replace src="%70" dst="p"/>
		<cxsltl:string.replace src="%71" dst="q"/>
		<cxsltl:string.replace src="%72" dst="r"/>
		<cxsltl:string.replace src="%73" dst="s"/>
		<cxsltl:string.replace src="%74" dst="t"/>
		<cxsltl:string.replace src="%75" dst="u"/>
		<cxsltl:string.replace src="%76" dst="v"/>
		<cxsltl:string.replace src="%77" dst="w"/>
		<cxsltl:string.replace src="%78" dst="x"/>
		<cxsltl:string.replace src="%79" dst="y"/>
		<cxsltl:string.replace src="%7A" dst="z"/>
		<cxsltl:string.replace src="%30" dst="0"/>
		<cxsltl:string.replace src="%31" dst="1"/>
		<cxsltl:string.replace src="%32" dst="2"/>
		<cxsltl:string.replace src="%33" dst="3"/>
		<cxsltl:string.replace src="%34" dst="4"/>
		<cxsltl:string.replace src="%35" dst="5"/>
		<cxsltl:string.replace src="%36" dst="6"/>
		<cxsltl:string.replace src="%37" dst="7"/>
		<cxsltl:string.replace src="%38" dst="8"/>
		<cxsltl:string.replace src="%39" dst="9"/>
		<cxsltl:string.replace src="%2D" dst="-"/>
		<cxsltl:string.replace src="%2E" dst="."/>
		<cxsltl:string.replace src="%5F" dst="_"/>
		<cxsltl:string.replace src="%7E" dst="~"/>
	</cxsltl:string.search>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsl:template name="cxsltl:uri.normalizePercent">
		<xsl:param name="string" select="normalize-space()"/>

		<xsl:choose>
			<xsl:when test="contains($string, '%')">
				<xsl:variable name="before" select="substring-before($string, '%')"/>
				<xsl:variable name="after" select="substring-after($string, '%')"/>
				<xsl:variable name="hex" select="translate(substring($after, 1, 2), 'abcdef', 'ABCDEF')"/>

				<xsl:value-of select="$before"/>

				<xsl:choose>
					<xsl:when test="translate($hex, '0123456789ABCDEF', '')">
						<xsl:text>%25</xsl:text>

						<xsl:call-template name="cxsltl:uri.normalizePercent">
							<xsl:with-param name="string" select="$after"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$cxsltl:uri.percentDecode[@src = concat('%', $hex)]">
								<xsl:value-of select="$cxsltl:uri.percentDecode[@src = concat('%', $hex)]/@dst"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="concat('%', $hex)"/>
							</xsl:otherwise>
						</xsl:choose>

						<xsl:call-template name="cxsltl:uri.normalizePercent">
							<xsl:with-param name="string" select="substring($after, 3)"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="cxsltl:uri.parse">
		<xsl:param name="uri" select="normalize-space()"/>
		<xsl:param name="normalize" select="true()"/>
		<xsl:param name="delims" select="false()"/>
		<xsl:param name="callback" select="$cxsltl:uri.self/xsl:template[@name = 'cxsltl:uri.callback.parse']"/>
		<xsl:param name="param1"/>
		<xsl:param name="param2"/>
		<xsl:param name="param3"/>
		<xsl:param name="param4"/>
		<xsl:param name="param5"/>

		<xsl:variable name="scheme">
			<xsl:variable name="before" select="substring-before($uri, ':')"/>

			<xsl:if test="$before and not(translate($before, '+-.0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', ''))">
				<xsl:value-of select="concat($before, ':')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="authority">
			<xsl:if test="starts-with($uri, concat($scheme, '//'))">
				<xsl:variable name="afterScheme" select="substring-after($uri, concat($scheme, '//'))"/>
				<xsl:variable name="beforeSlash" select="string-length(substring-before($afterScheme, '/'))"/>
				<xsl:variable name="beforeQuestion" select="string-length(substring-before($afterScheme, '?'))"/>
				<xsl:variable name="beforeShape" select="string-length(substring-before($afterScheme, '#'))"/>

				<xsl:text>//</xsl:text>

				<xsl:choose>
					<xsl:when test="$beforeSlash and (not($beforeQuestion) or $beforeSlash &lt; $beforeQuestion) and (not($beforeShape) or $beforeSlash &lt; $beforeShape)">
						<xsl:value-of select="substring($afterScheme, 1, $beforeSlash)"/>
					</xsl:when>
					<xsl:when test="$beforeQuestion and (not($beforeSlash) or $beforeQuestion &lt; $beforeSlash) and (not($beforeShape) or $beforeQuestion &lt; $beforeShape)">
						<xsl:value-of select="substring($afterScheme, 1, $beforeQuestion)"/>
					</xsl:when>
					<xsl:when test="$beforeShape and (not($beforeSlash) or $beforeShape &lt; $beforeSlash) and (not($beforeQuestion) or $beforeShape &lt; $beforeQuestion)">
						<xsl:value-of select="substring($afterScheme, 1, $beforeShape)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$afterScheme"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="userinfo">
			<xsl:if test="contains($authority, '@')">
				<xsl:value-of select="concat(substring-before(substring-after($authority, '//'), '@'), '@')"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="host">
			<xsl:variable name="afterUserinfo" select="substring-after($authority, concat('//', $userinfo))"/>

			<xsl:choose>
				<xsl:when test="contains($afterUserinfo, '[')">
					<xsl:value-of select="concat(substring-before($afterUserinfo, ']'), ']')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="cxsltl:string.substringBefore">
						<xsl:with-param name="string" select="$afterUserinfo"/>
						<xsl:with-param name="substring">:</xsl:with-param>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="port">
			<xsl:if test="starts-with($authority, concat('//', $userinfo, $host, ':'))">
				<xsl:value-of select="substring-after($authority, concat('//', $userinfo, $host))"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="path">
			<xsl:if test="starts-with($uri, concat($scheme, $authority))">
				<xsl:variable name="afterAuthority" select="substring-after($uri, concat($scheme, $authority))"/>
				<xsl:variable name="beforeQuestion" select="string-length(substring-before($afterAuthority, '?'))"/>
				<xsl:variable name="beforeShape" select="string-length(substring-before($afterAuthority, '#'))"/>

				<xsl:choose>
					<xsl:when test="contains($afterAuthority, '?') and (not($beforeShape) or $beforeQuestion &lt; $beforeShape)">
						<xsl:value-of select="substring($afterAuthority, 1, $beforeQuestion)"/>
					</xsl:when>
					<xsl:when test="contains($afterAuthority, '#') and (not($beforeQuestion) or $beforeShape &lt; $beforeQuestion)">
						<xsl:value-of select="substring($afterAuthority, 1, $beforeShape)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$afterAuthority"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="query">
			<xsl:if test="starts-with($uri, concat($scheme, $authority, $path, '?'))">
				<xsl:text>?</xsl:text>

				<xsl:call-template name="cxsltl:string.substringBefore">
					<xsl:with-param name="string" select="substring-after($uri, concat($scheme, $authority, $path, '?'))"/>
					<xsl:with-param name="substring">#</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="fragment">
			<xsl:if test="contains($uri, '#')">
				<xsl:value-of select="concat('#', substring-after($uri, '#'))"/>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="normalizedScheme" select="translate($scheme, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:variable name="normalizedUserinfo">
			<xsl:choose>
				<xsl:when test="$normalize">
					<xsl:call-template name="cxsltl:uri.normalizePercent">
						<xsl:with-param name="string" select="$userinfo"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$userinfo"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="normalizedHost">
			<xsl:choose>
				<xsl:when test="$normalize">
					<xsl:call-template name="cxsltl:uri.normalizePercent">
						<xsl:with-param name="string" select="translate($host, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$host"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="normalizedPort">
			<xsl:choose>
				<xsl:when test="$normalize and substring-after($port, ':')">
					<xsl:value-of select="concat(':', number(substring-after($port, ':')))"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$port"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="normalizedAuthority">
			<xsl:if test="string($authority)">//</xsl:if>

			<xsl:value-of select="concat($normalizedUserinfo, $normalizedHost, $normalizedPort)"/>
		</xsl:variable>
		<xsl:variable name="normalizedPath">
			<xsl:choose>
				<xsl:when test="$normalize">
					<xsl:call-template name="cxsltl:uri.normalizePercent">
						<xsl:with-param name="string" select="$path"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$path"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="normalizedQuery">
			<xsl:choose>
				<xsl:when test="$normalize">
					<xsl:call-template name="cxsltl:uri.normalizePercent">
						<xsl:with-param name="string" select="$query"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$query"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="normalizedFragment">
			<xsl:choose>
				<xsl:when test="$normalize">
					<xsl:call-template name="cxsltl:uri.normalizePercent">
						<xsl:with-param name="string" select="$fragment"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$fragment"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="$delims">
				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="scheme" select="$normalizedScheme"/>
					<xsl:with-param name="authority" select="$normalizedAuthority"/>
					<xsl:with-param name="userinfo" select="$normalizedUserinfo"/>
					<xsl:with-param name="host" select="$normalizedHost"/>
					<xsl:with-param name="port" select="$normalizedPort"/>
					<xsl:with-param name="path" select="$normalizedPath"/>
					<xsl:with-param name="query" select="$normalizedQuery"/>
					<xsl:with-param name="fragment" select="$normalizedFragment"/>
					<xsl:with-param name="param1" select="$param1"/>
					<xsl:with-param name="param2" select="$param2"/>
					<xsl:with-param name="param3" select="$param3"/>
					<xsl:with-param name="param4" select="$param4"/>
					<xsl:with-param name="param5" select="$param5"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="scheme" select="substring-before($normalizedScheme, ':')"/>
					<xsl:with-param name="authority" select="substring-after($normalizedAuthority, '//')"/>
					<xsl:with-param name="userinfo" select="substring-before($normalizedUserinfo, '@')"/>
					<xsl:with-param name="host" select="$normalizedHost"/>
					<xsl:with-param name="port" select="substring-after($normalizedPort, ':')"/>
					<xsl:with-param name="path" select="$normalizedPath"/>
					<xsl:with-param name="query" select="substring-after($normalizedQuery, '?')"/>
					<xsl:with-param name="fragment" select="substring-after($normalizedFragment, '#')"/>
					<xsl:with-param name="param1" select="$param1"/>
					<xsl:with-param name="param2" select="$param2"/>
					<xsl:with-param name="param3" select="$param3"/>
					<xsl:with-param name="param4" select="$param4"/>
					<xsl:with-param name="param5" select="$param5"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:uri.callback.parse']" mode="cxsltl:callback" name="cxsltl:uri.callback.parse">
		<xsl:param name="scheme"/>
		<xsl:param name="authority"/>
		<xsl:param name="userinfo"/>
		<xsl:param name="host"/>
		<xsl:param name="port"/>
		<xsl:param name="path"/>
		<xsl:param name="query"/>
		<xsl:param name="fragment"/>

		<xsl:value-of select="concat(
			'scheme ', $scheme, '&#xA;',
			'authority ', $authority, '&#xA;',
			'userinfo ', $userinfo, '&#xA;',
			'host ', $host, '&#xA;',
			'port ', $port, '&#xA;',
			'path ', $path, '&#xA;',
			'query ', $query, '&#xA;',
			'fragment ', $fragment, '&#xA;'
		)"/>
	</xsl:template>

	<xsl:template name="cxsltl:uri.relativeResolution">
		<xsl:param name="reference" select="normalize-space()"/>
		<xsl:param name="normalize" select="true()"/>
		<xsl:param name="base">
			<xsl:call-template name="cxsltl:uri.baseResolution">
				<xsl:with-param name="normalize" select="$normalize"/>
			</xsl:call-template>
		</xsl:param>

		<xsl:variable name="parse">
			<xsl:call-template name="cxsltl:uri.parse">
				<xsl:with-param name="uri" select="$reference"/>
				<xsl:with-param name="delims" select="true()"/>
				<xsl:with-param name="normalize" select="$normalize"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="scheme" select="substring-before(substring-after($parse, 'scheme '), '&#xA;')"/>
		<xsl:variable name="authority" select="substring-before(substring-after($parse, 'authority '), '&#xA;')"/>
		<xsl:variable name="path" select="substring-before(substring-after($parse, 'path '), '&#xA;')"/>
		<xsl:variable name="query" select="substring-before(substring-after($parse, 'query '), '&#xA;')"/>
		<xsl:variable name="fragment" select="substring-before(substring-after($parse, 'fragment '), '&#xA;')"/>

		<xsl:variable name="parseBase">
			<xsl:call-template name="cxsltl:uri.parse">
				<xsl:with-param name="uri" select="$base"/>
				<xsl:with-param name="delims" select="true()"/>
				<xsl:with-param name="normalize" select="$normalize"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="baseScheme" select="substring-before(substring-after($parseBase, 'scheme '), '&#xA;')"/>
		<xsl:variable name="baseAuthority" select="substring-before(substring-after($parseBase, 'authority '), '&#xA;')"/>
		<xsl:variable name="basePath" select="substring-before(substring-after($parseBase, 'path '), '&#xA;')"/>
		<xsl:variable name="baseQuery" select="substring-before(substring-after($parseBase, 'query '), '&#xA;')"/>

		<xsl:choose>
			<xsl:when test="string($scheme)">
				<xsl:value-of select="concat($scheme, $authority, $path, $query, $fragment)"/>
			</xsl:when>
			<xsl:when test="starts-with($reference, '//')">
				<xsl:value-of select="concat($baseScheme, $authority, $path, $query, $fragment)"/>
			</xsl:when>
			<xsl:when test="starts-with($reference, '?')">
				<xsl:value-of select="concat($baseScheme, $baseAuthority, $basePath, $query, $fragment)"/>
			</xsl:when>
			<xsl:when test="starts-with($reference, '#') or $reference = ''">
				<xsl:value-of select="concat($baseScheme, $baseAuthority, $basePath, $baseQuery, $fragment)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($baseScheme, $baseAuthority)"/>

				<xsl:call-template name="cxsltl:uri.removeDotSegments">
					<xsl:with-param name="path">
						<xsl:if test="not(starts-with($path, '/'))">
							<xsl:choose>
								<xsl:when test="contains($basePath, '/')">
									<xsl:call-template name="cxsltl:string.lastSubstringBefore">
										<xsl:with-param name="string" select="$basePath"/>
										<xsl:with-param name="substring">/</xsl:with-param>
									</xsl:call-template>

									<xsl:text>/</xsl:text>
								</xsl:when>
								<xsl:when test="string($baseAuthority)">/</xsl:when>
							</xsl:choose>
						</xsl:if>

						<xsl:value-of select="$path"/>
					</xsl:with-param>
				</xsl:call-template>

				<xsl:value-of select="concat($query, $fragment)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="cxsltl:uri.removeDotSegments">
		<xsl:param name="path" select="normalize-space()"/>
		<xsl:param name="_normalized"/>

		<xsl:choose>
			<xsl:when test="$path = '' or $path = '..' or $path = '.'">
				<xsl:value-of select="$_normalized"/>
			</xsl:when>
			<xsl:when test="starts-with($path, '../') or starts-with($path, './')">
				<xsl:call-template name="cxsltl:uri.removeDotSegments">
					<xsl:with-param name="path" select="substring-after($path, '/')"/>
					<xsl:with-param name="_normalized" select="$_normalized"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="starts-with($path, '/./')">
				<xsl:call-template name="cxsltl:uri.removeDotSegments">
					<xsl:with-param name="path" select="substring($path, 3)"/>
					<xsl:with-param name="_normalized" select="$_normalized"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$path = '/.'">
				<xsl:value-of select="concat($_normalized, '/')"/>
			</xsl:when>
			<xsl:when test="starts-with($path, '/../')">
				<xsl:call-template name="cxsltl:uri.removeDotSegments">
					<xsl:with-param name="path" select="substring($path, 4)"/>
					<xsl:with-param name="_normalized">
						<xsl:call-template name="cxsltl:string.lastSubstringBefore">
							<xsl:with-param name="string" select="$_normalized"/>
							<xsl:with-param name="substring">/</xsl:with-param>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$path = '/..'">
				<xsl:call-template name="cxsltl:string.lastSubstringBefore">
					<xsl:with-param name="string" select="$_normalized"/>
					<xsl:with-param name="substring">/</xsl:with-param>
				</xsl:call-template>

				<xsl:text>/</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="before">
					<xsl:call-template name="cxsltl:string.substringBefore">
						<xsl:with-param name="string" select="substring($path, 2)"/>
						<xsl:with-param name="substring">/</xsl:with-param>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="beforeLength" select="string-length($before) + 1"/>

				<xsl:call-template name="cxsltl:uri.removeDotSegments">
					<xsl:with-param name="path" select="substring($path, $beforeLength + 1)"/>
					<xsl:with-param name="_normalized" select="concat($_normalized, substring($path, 1, $beforeLength))"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="cxsltl:uri.baseResolution">
		<xsl:param name="base" select="ancestor-or-self::*[@xml:base]"/>
		<xsl:param name="normalize" select="true()"/>
		<xsl:param name="_base"/>

		<xsl:choose>
			<xsl:when test="$base[@xml:base]">
				<xsl:call-template name="cxsltl:uri.baseResolution">
					<xsl:with-param name="base" select="($base[@xml:base])[position() != 1]"/>
					<xsl:with-param name="normalize" select="$normalize"/>
					<xsl:with-param name="_base">
						<xsl:call-template name="cxsltl:uri.relativeResolution">
							<xsl:with-param name="reference" select="normalize-space($base/@xml:base)"/>
							<xsl:with-param name="normalize" select="$normalize"/>
							<xsl:with-param name="base" select="$_base"/>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$_base"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>