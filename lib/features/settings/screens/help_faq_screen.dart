import 'package:flutter/material.dart';
import '../../../shared/theme/app_layout.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  String _lang(BuildContext context) => Localizations.localeOf(context).languageCode;

  String _tr(BuildContext context, String en, String fa, [String? ps]) {
    final code = _lang(context);
    if (code == 'ps') return ps ?? fa;
    if (code == 'fa') return fa;
    return en;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_tr(context, 'Help & FAQ', 'راهنما و سوالات', 'مرسته او پوښتنې')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.m),
        children: [
          _buildQuickStartGuide(context),
          const SizedBox(height: AppSpacing.l),
          _buildCategoryHeader(context, _tr(context, 'Sales & Products', 'فروش و محصولات', 'پلور او محصولات'), Icons.shopping_basket_outlined),
          _buildFAQItem(
            context,
            _tr(context, 'How to record a sale?', 'چطور فروش ثبت کنم؟', 'پلور څنګه ثبت کړم؟'),
            _tr(context, 
              'Go to the Sales tab, search for products or scan barcodes. Tap on products to add them to your cart. Once finished, tap the Checkout button to confirm the sale.', 
              'به بخش فروش بروید، محصولات را جستجو کنید یا بارکد بزنید. برای افزودن به سبد خرید روی محصول کلیک کنید. در پایان دکمه ثبت (Checkout) را برای نهایی کردن فروش بزنید.', 
              'د پلور برخې ته لاړ شئ، محصولات ولټوئ یا بارکډونه سکین کړئ. په محصولاتو کلیک وکړئ ترڅو په کڅوړه کې اضافه شي. په پای کې د پلور تایید لپاره د ثبت تڼۍ کېکاږئ.'
            ),
          ),
          _buildFAQItem(
            context,
            _tr(context, 'Can I apply discounts?', 'آیا می‌توانم تخفیف بدهم؟', 'ایا زه تخفیف ورکولی شم؟'),
            _tr(context, 
              'Yes! In the Sale Review screen, you can add a global discount or tap on individual items to apply a discount to a specific product.', 
              'بله! در صفحه بازبینی فروش، می‌توانید تخفیف کلی اضافه کنید یا با کلیک روی هر محصول، برای آن تخفیف خاصی در نظر بگیرید.', 
              'هو! د پلور د بیاکتنې په پاڼه کې، تاسو کولی شئ عمومي تخفیف اضافه کړئ یا په انفرادي محصولاتو کلیک وکړئ ترڅو د ځانګړي محصول لپاره تخفیف پلي کړئ.'
            ),
          ),
          _buildFAQItem(
            context,
            _tr(context, 'How to add new products?', 'چطور محصول جدید اضافه کنم؟', 'نوي محصولات څنګه اضافه کړم؟'),
            _tr(context, 
              'Go to Inventory, tap the (+) button. You can enter the name, cost price, selling price, and even scan a barcode to quickly add products.', 
              'به بخش موجودی (Inventory) بروید و دکمه (+) را بزنید. می‌توانید نام، قیمت خرید، قیمت فروش را وارد کنید و حتی برای محصول بارکد ثبت کنید.', 
              'د زېرمې برخې ته لاړ شئ، د (+) تڼۍ کېکاږئ. تاسو کولی شئ نوم، د پیرود قیمت، د پلور قیمت دننه کړئ او حتی د محصولاتو په چټکۍ سره اضافه کولو لپاره بارکډ سکین کړئ.'
            ),
          ),

          const SizedBox(height: AppSpacing.l),
          _buildCategoryHeader(context, _tr(context, 'Debt (Qarz) Management', 'مدیریت قرض‌ها', 'د پورونو مدیریت'), Icons.people_outline),
          _buildFAQItem(
            context,
            _tr(context, 'How to track customer debt?', 'چطور طلب‌کاری‌ها را ثبت کنم؟', 'د پیرودونکو پورونه څنګه تعقیب کړم؟'),
            _tr(context, 
              'When making a sale, select "Credit Sale" and choose a customer. Their total balance will automatically update in the Qarz section.', 
              'هنگام فروش، گزینه "فروش نسیه" را انتخاب کرده و مشتری را تعیین کنید. بیلانس کلی آن‌ها در بخش قرض‌ها به‌طور خودکار آپدیت می‌شود.', 
              'د پلور پر مهال، "نسي پلور" غوره کړئ او پیرودونکی وټاکئ. د دوی ټول بیلانس به په اتوماتیک ډول د پورونو په برخه کې تازه شي.'
            ),
          ),
          _buildFAQItem(
            context,
            _tr(context, 'How to record a payment?', 'چطور دریافت پول ثبت کنم؟', 'د پیسې ترلاسه کول څنګه ثبت کړم؟'),
            _tr(context, 
              'Go to the Qarz dashboard, select the customer, and tap "Record Payment". This will reduce their outstanding balance.', 
              'در داشبورد قرض‌ها، مشتری را انتخاب کرده و روی "ثبت تادیه" کلیک کنید. این کار مبلغ بدهی آن‌ها را کم می‌کند.', 
              'د پورونو ډشبورډ ته لاړ شئ، پیرودونکی وټاکئ او "تادیه ثبت کړئ" باندې کلیک وکړئ. دا به د دوی پاتې پور کم کړي.'
            ),
          ),
          _buildFAQItem(
            context,
            _tr(context, 'Can I send reminders?', 'آیا می‌توانم یادآوری بفرستم؟', 'ایا زه یادونه لیږلی شم؟'),
            _tr(context, 
              'Yes! In the Customer details screen, tap the WhatsApp icon. The app will generate a message in Pashto, Dari, or English with the current balance.', 
              'بله! در صفحه جزئیات مشتری، روی آیکون واتساپ کلیک کنید. اپلیکیشن پیامی به زبان پشتو، دری یا انگلیسی برای مشتری آماده می‌کند.', 
              'هو! د پیرودونکي د توضیحاتو په پاڼه کې، د واټساپ آیکون باندې کلیک وکړئ. اپلیکیشن به په پښتو، دري یا انګلیسي کې د اوسني بیلانس سره یو پیغام چمتو کړي.'
            ),
          ),

          const SizedBox(height: AppSpacing.l),
          _buildCategoryHeader(context, _tr(context, 'Reports & Sync', 'گزارش‌ها و همگام‌سازی', 'راپورونه او همغږي'), Icons.analytics_outlined),
          _buildFAQItem(
            context,
            _tr(context, 'What is Daily Summary?', 'خلاصه روزانه چیست؟', 'ورځنی لنډیز څه شی دی؟'),
            _tr(context, 
              'It gives you a quick look at your total sales, collected cash, new debts, and estimated profit for the current day.', 
              'خلاصه روزانه دید سریعی از فروش کل، نقدینگی وصول شده، قرض‌های جدید و سود تخمینی امروز به شما می‌دهد.', 
              'دا تاسو ته د نن ورځې لپاره ستاسو د ټولو پلورونو، راټول شویو نغدو پیسو، نوي پورونو او اټکل شوې ګټې په اړه یو چټک نظر درکوي.'
            ),
          ),
          _buildFAQItem(
            context,
            _tr(context, 'Is internet required?', 'آیا اینترنت لازم است؟', 'ایا انټرنیټ ته اړتیا ده؟'),
            _tr(context, 
              'No. Hesabat is built for offline use in Afghanistan. You only need internet to backup data to the cloud or sync between devices.', 
              'نخیر. حسابات برای استفاده آفلاین ساخته شده است. شما فقط برای بک‌آپ یا همگام‌سازی بین دستگاه‌ها به اینترنت نیاز دارید.', 
              'نه. حسابات په افغانستان کې د افلاین کارونې لپاره جوړ شوی. تاسو یوازې د کلاوډ یا د وسایلو ترمنځ همغږۍ لپاره انټرنیټ ته اړتیا لرئ.'
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
          _buildSupportSection(context),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String q, String a) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.1)),
      ),
      child: ExpansionTile(
        title: Text(q, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        expandedAlignment: Alignment.centerLeft,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          Text(a, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildQuickStartGuide(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _tr(context, 'Quick Start Guide', 'راهنمای چابک', 'چټک لارښود'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _buildStepRow(context, '1', _tr(context, 'Register your products in Inventory.', 'محصولات را در موجودی ثبت کنید.', 'محصولات په زېرمه کې ثبت کړئ.')),
          _buildStepRow(context, '2', _tr(context, 'Go to Sales to record your first transaction.', 'برای اولین فروش به بخش فروش بروید.', 'د لومړي پلور لپاره د پلور برخې ته لاړ شئ.')),
          _buildStepRow(context, '3', _tr(context, 'Manage customer debt in the Qarz section.', 'بدهی مشتریان را در بخش قرض مدیریت کنید.', 'د پیرودونکو پور په پور برخې کې مدیریت کړئ.')),
        ],
      ),
    );
  }

  Widget _buildStepRow(BuildContext context, String step, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Text(step, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Column(
      children: [
        Text(
          _tr(context, "Still need help?", "هنوز به کمک نیاز دارید؟", "لا هم مرستې ته اړتیا لرئ؟"),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
             // This will be handled by the parent screen for now or we can implement it here.
             // But usually it's better to just navigate back to contact support.
             Navigator.pop(context);
          },
          icon: const Icon(Icons.support_agent),
          label: Text(_tr(context, 'Contact Support', 'تماس با پشتیبانی', 'د ملاتړ اړیکه')),
        ),
      ],
    );
  }
}
