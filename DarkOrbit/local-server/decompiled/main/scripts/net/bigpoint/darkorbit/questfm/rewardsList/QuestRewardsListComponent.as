package net.bigpoint.darkorbit.questfm.rewardsList
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.ui.panels.VPanel;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import net.bigpoint.darkorbit.Styles;
   
   public class QuestRewardsListComponent extends Sprite
   {
      
      public static const SIZE_CHANGED:String = "sizeChanged";
      
      private static const TITLE_WIDTH:int = 245;
      
      private var _vPanel:VPanel;
      
      private var _isDefaultVisible:Boolean;
      
      private var _questTitleF:TextField;
      
      public function QuestRewardsListComponent()
      {
         super();
         this.initQuestTitleTextField();
         addChild(this._vPanel = new VPanel());
         this._vPanel.y = this._questTitleF.y + this._questTitleF.height - 8;
      }
      
      public function initQuestTitleTextField() : void
      {
         if(Boolean(this._questTitleF) && contains(this._questTitleF))
         {
            removeChild(this._questTitleF);
         }
         var _loc1_:TextFormat = new TextFormat(Styles.strongStdFmt.font,Styles.strongStdFmt.size,15327936);
         this._questTitleF = new TextField();
         this._questTitleF.defaultTextFormat = _loc1_;
         this._questTitleF.embedFonts = Styles.strongStdEmbed;
         this._questTitleF.antiAliasType = AntiAliasType.ADVANCED;
         this._questTitleF.mouseEnabled = true;
         this._questTitleF.selectable = false;
         this._questTitleF.width = TITLE_WIDTH;
         addChild(this._questTitleF);
         this._questTitleF.height = 18;
         this._questTitleF.y = 4;
      }
      
      public function set questTitle(param1:String) : void
      {
         var _loc2_:Boolean = false;
         this.initQuestTitleTextField();
         param1 ||= "";
         if(contains(this._questTitleF) && Boolean(param1.length))
         {
            _loc2_ = TextFormatter.distillAndWrite(param1,this._questTitleF);
            if(_loc2_)
            {
               TooltipControl.getInstance().addToolTip(this._questTitleF,param1);
            }
         }
      }
      
      public function get isDefaultVisible() : Boolean
      {
         return this._isDefaultVisible;
      }
      
      public function set isDefaultVisible(param1:Boolean) : void
      {
         this._isDefaultVisible = param1;
      }
      
      public function get visibleHeight() : int
      {
         return this.height;
      }
      
      public function get vPanel() : VPanel
      {
         return this._vPanel;
      }
   }
}

