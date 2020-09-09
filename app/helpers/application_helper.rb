module ApplicationHelper
  def default_meta_tags
    {
      site: 'ProgrammingDrill',
      title: 'プログラミングドリル',
      reverse: true,
      charset: 'utf-8',
      description: 'プログラミング学習者が過去に作成したWebアプリを投稿、共有し、学習教材として利用できます！つくったものはどんどん投稿し、さらに新しい技術を学習していこう！',
      keywords: 'プログラミング, エンジニア, ポートフォリオ',
      canonical: request.original_url,
      separator: '|',
      icon: [
        { href: image_url('favicon.ico') },
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('favicon.ico'),
        local: 'ja-JP',
      },
      twitter: {
        card: 'summary',
        site: '@RAMhamahitsuji',
      }
    }
  end
end
