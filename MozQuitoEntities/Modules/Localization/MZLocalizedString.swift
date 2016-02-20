import Foundation

/// Machine generated function enumerating MZLocalizationKey keys using a `switch` to ensure each key has an `NSLocalizedString(...)` entry.
public func MZLocalizedString(key:MZLocalizationKey) -> String {
    switch key {
    case .URLMozscapeAuthoritySpamScore:
        return NSLocalizedString("URLMozscapeAuthoritySpamScore", value:"Spam Score", comment:"The subtitle for the mozscape spam score")
    case .URLMozscapeLinksInfo:
        return NSLocalizedString("URLMozscapeLinksInfo", value:"<#value#>", comment:"The help info shown for the links section of the mozscape panel")
    case .URLMozscapeAuthorityPage:
        return NSLocalizedString("URLMozscapeAuthorityPage", value:"Page Authority", comment:"The subtitle for the mozscape page authority")
    case .URLMozscapeLinksTitle:
        return NSLocalizedString("URLMozscapeLinksTitle", value:"ESTABLISHED LINKS", comment:"The title for the Links section of the mozscape panel")
    case .URLLinksTitle:
        return NSLocalizedString("URLLinksTitle", value:"Links", comment:"The tab title for the links tab on the URL details screen.")
    case .URLPageMetaDataMetaDescription:
        return NSLocalizedString("URLPageMetaDataMetaDescription", value:"Meta Description", comment:"The title on the meta data panel for the page description")
    case .URLPageMetaDataH2Tags:
        return NSLocalizedString("URLPageMetaDataH2Tags", value:"H2", comment:"The title on the meta data panel for the h2 tag elements")
    case .URLMozscapeLinksRootDomain:
        return NSLocalizedString("URLMozscapeLinksRootDomain", value:"Root Domains", comment:"The subtitle for the number of Root Domains in the links section of the mozscape panel")
    case .URLDataSearchHint:
        return NSLocalizedString("URLDataSearchHint", value:"Search For Metrics", comment:"The text field hint on the URL Data page.")
    case .URLMozscapeAuthorityDomain:
        return NSLocalizedString("URLMozscapeAuthorityDomain", value:"Domain Authority", comment:"The subtitle for the mozscape domain authority")
    case .URLPageMetaDataPageTitle:
        return NSLocalizedString("URLPageMetaDataPageTitle", value:"Page Title", comment:"The title on the meta data panel for the page title")
    case .URLMozscapeAuthorityInfo:
        return NSLocalizedString("URLMozscapeAuthorityInfo", value:"<#value#>", comment:"The help info shown for the authority section of the mozscape panel")
    case .URLMozscapeLinksTotalLinks:
        return NSLocalizedString("URLMozscapeLinksTotalLinks", value:"Total Links", comment:"The subtitle for the total number of links in the links section of the mozscape panel")
    case .URLMozscapeNextIndexedTitle:
        return NSLocalizedString("URLMozscapeNextIndexedTitle", value:"NEXT INDEXING", comment:"The subtitle of the next index date on the mozscape panel")
    case .URLPageMetaDataHeadline:
        return NSLocalizedString("URLPageMetaDataHeadline", value:"HTML Metadata", comment:"The headline on the top of the HTML Metadata page.")
    case .URLPageMetaDataCanonicalURL:
        return NSLocalizedString("URLPageMetaDataCanonicalURL", value:"Canonincal URL", comment:"The title on the meta data panel for the canonical url")
    case .URLMozscapeAuthorityTitle:
        return NSLocalizedString("URLMozscapeAuthorityTitle", value:"AUTHORITY", comment:"The title for the Authroity section of the Mozscape panel")
    case .URLMozscapeLastIndexedTitle:
        return NSLocalizedString("URLMozscapeLastIndexedTitle", value:"LAST INDEXED", comment:"The subtitle of the last index date on the mozscape panel")
    case .URLPageMetaDataH1Tags:
        return NSLocalizedString("URLPageMetaDataH1Tags", value:"H1", comment:"The title on the meta data panel for the h1 tag elements")
    case .URLPageMetaDataUsingSSL:
        return NSLocalizedString("URLPageMetaDataUsingSSL", value:"Using SSL", comment:"The title on the meta data panel for whether the site is using SSL")
    case .URLMetricsTitle:
        return NSLocalizedString("URLMetricsTitle", value:"URL Metrics", comment:"The tab title for the URL Metrics tab.")
    default:
        return MZLocalization.localStrings?[key]?.value ?? "Not Yet Set"
    }
}