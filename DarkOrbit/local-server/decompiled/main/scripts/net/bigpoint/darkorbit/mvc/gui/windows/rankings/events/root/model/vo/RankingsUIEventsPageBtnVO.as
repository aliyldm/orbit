package net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.model.vo
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   
   public class RankingsUIEventsPageBtnVO
   {
      
      public static const TYPE_OVERALL:int = 0;
      
      public static const TYPE_TODAY:int = 1;
      
      public static const TYPE_YESTERDAY:int = 2;
      
      public const selected:BindableBoolean = new BindableBoolean();
      
      private var _type:int;
      
      private var _pageTitle:String;
      
      public function RankingsUIEventsPageBtnVO(param1:int)
      {
         super();
         this._type = param1;
         switch(this._type)
         {
            case TYPE_TODAY:
               this._pageTitle = BPLocale.getItem("events_subtab_today");
               break;
            case TYPE_YESTERDAY:
               this._pageTitle = BPLocale.getItem("events_subtab_yesterday");
               break;
            default:
               this._pageTitle = BPLocale.getItem("events_subtab_overall");
         }
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get titleKey() : String
      {
         return this._pageTitle;
      }
      
      public function get title() : String
      {
         return this._pageTitle;
      }
   }
}

