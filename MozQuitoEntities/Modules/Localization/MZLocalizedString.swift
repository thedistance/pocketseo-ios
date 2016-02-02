import Foundation

/// Machine generated function enumerating MZLocalizationKey keys using a `switch` to ensure each key has an `NSLocalizedString(...)` entry.
public func MZLocalizedString(key:MZLocalizationKey) -> String {
switch key {
case .URLMozscapeLinksTitle:
return NSLocalizedString("URLMozscapeLinksTitle", value:"Established Links", comment:"The title for the Links section of the mozscape panel")
case .URLMozscapeNextIndexedTitle:
return NSLocalizedString("URLMozscapeNextIndexedTitle", value:"Next Indexing", comment:"The subtitle of the next index date on the mozscape panel")
case .URLMozscapeAuthoritySpamScore:
return NSLocalizedString("URLMozscapeAuthoritySpamScore", value:"Spam Score", comment:"The subtitle for the mozscape spam score")
case .URLMozscapeLinksTotalLinks:
return NSLocalizedString("URLMozscapeLinksTotalLinks", value:"Total Links", comment:"The subtitle for the total number of links in the links section of the mozscape panel")
case .URLPageMetaDataH2Tags:
return NSLocalizedString("URLPageMetaDataH2Tags", value:"H2", comment:"The title on the meta data panel for the h2 tag elements")
case .URLMozscapeAuthorityTitle:
return NSLocalizedString("URLMozscapeAuthorityTitle", value:"Authority", comment:"The title for the Authroity section of the Mozscape panel")
case .URLMozscapeLinksInfo:
return NSLocalizedString("URLMozscapeLinksInfo", value:"<#value#>", comment:"The help info shown for the links section of the mozscape panel")
case .URLDataSearchHint:
return NSLocalizedString("URLDataSearchHint", value:"Get Metrics for...", comment:"The text field hint on the URL Data page.")
case .URLMozscapeAuthorityInfo:
return NSLocalizedString("URLMozscapeAuthorityInfo", value:"<#value#>", comment:"The help info shown for the authority section of the mozscape panel")
case .URLPageMetaDataMetaDescription:
return NSLocalizedString("URLPageMetaDataMetaDescription", value:"Meta Description", comment:"The title on the meta data panel for the page description")
case .URLMozscapeLinksRootDomain:
return NSLocalizedString("URLMozscapeLinksRootDomain", value:"Root Domains", comment:"The subtitle for the number of Root Domains in the links section of the mozscape panel")
case .URLMozscapeLastIndexedTitle:
return NSLocalizedString("URLMozscapeLastIndexedTitle", value:"Last Indexed", comment:"The subtitle of the last index date on the mozscape panel")
case .URLPageMetaDataCanonicalURL:
return NSLocalizedString("URLPageMetaDataCanonicalURL", value:"Canonincal URL", comment:"The title on the meta data panel for the canonical url")
case .URLPageMetaDataH1Tags:
return NSLocalizedString("URLPageMetaDataH1Tags", value:"H1", comment:"The title on the meta data panel for the h1 tag elements")
case .URLMozscapeAuthorityDomain:
return NSLocalizedString("URLMozscapeAuthorityDomain", value:"Domain Authorith", comment:"The subtitle for the mozscape domain authority")
case .URLPageMetaDataUsingSSL:
return NSLocalizedString("URLPageMetaDataUsingSSL", value:"Using SSL", comment:"The title on the meta data panel for whether the site is using SSL")
case .URLMozscapeAuthorityPage:
return NSLocalizedString("URLMozscapeAuthorityPage", value:"Page Authority", comment:"The subtitle for the mozscape page authority")
case .URLPageMetaDataPageTitle:
return NSLocalizedString("URLPageMetaDataPageTitle", value:"Page Title", comment:"The title on the meta data panel for the page title")
default:
return MZLocalization.localStrings?[key]?.value ?? "Not Yet Set"
}
}