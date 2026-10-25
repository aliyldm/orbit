package net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.renderers.questList
{
   import com.greensock.TweenLite;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flashx.textLayout.conversion.TextConverter;
   import mx.events.PropertyChangeEvent;
   import net.bigpoint.darkorbit.com.module.QuestTypeModule;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.questWindow.model.vo.QuestListItemVO;
   import net.bigpoint.darkorbit.mvc.questWindow.view.events.QuestGiverWindowEvent;
   import spark.components.RichText;
   
   public class QuestListItemRendererContent extends QuestListItemRendererContentComponent
   {
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _questListItemVO:QuestListItemVO;
      
      private var _1106023393_normalBitmapData:BitmapData;
      
      private var _selectedBitmapData:BitmapData;
      
      private var _disabledBitmapData:BitmapData;
      
      private var _rollOverBitmapData:BitmapData;
      
      private var _inProgressBitmapData:BitmapData;
      
      private var _completedBitmapData:BitmapData;
      
      private var _lockedBitmapData:BitmapData;
      
      private var _1318480814_scale9Rect:Rectangle;
      
      private var _questAdditionalInfo:RichText;
      
      public function QuestListItemRendererContent()
      {
         super();
         this._normalBitmapData = ResourceManager.getBitmapData("questWin","quest_list_item_normal");
         this._selectedBitmapData = ResourceManager.getBitmapData("questWin","quest_list_item_selected");
         this._disabledBitmapData = ResourceManager.getBitmapData("questWin","quest_list_item_disabled");
         this._completedBitmapData = ResourceManager.getBitmapData("questWin","quest_list_item_completed");
         this._rollOverBitmapData = ResourceManager.getBitmapData("questWin","quest_list_item_rollover");
         this._inProgressBitmapData = ResourceManager.getBitmapData("questWin","quest_list_item_in_progress");
         this._lockedBitmapData = ResourceManager.getBitmapData("questWin","quest_list_item_locked");
         mouseChildren = false;
         buttonMode = true;
      }
      
      private function init() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         this._questAdditionalInfo = questAdditionalInfo;
         this._normalBitmapData = ResourceManager.getBitmapData("questWin","quest_list_item_normal");
         questNameLabel.textFlow = TextConverter.importToFlow(this._questListItemVO.questListHTMLtitle,TextConverter.TEXT_FIELD_HTML_FORMAT);
         if(this._questListItemVO.questListHTMLaddon != null && this._questListItemVO.questListHTMLaddon != "")
         {
            if(questAdditionalInfo)
            {
               questAdditionalInfo.textFlow = TextConverter.importToFlow(this._questListItemVO.questListHTMLaddon,TextConverter.TEXT_FIELD_HTML_FORMAT);
               if(!textsContainer.containsElement(this._questAdditionalInfo))
               {
                  textsContainer.addElement(this._questAdditionalInfo);
               }
            }
         }
         else if(questAdditionalInfo != null && textsContainer.containsElement(this._questAdditionalInfo))
         {
            textsContainer.removeElement(this._questAdditionalInfo);
         }
         if(this._questListItemVO.acceptable || this._questListItemVO.completed || this._questListItemVO.getQuestActive())
         {
            _loc1_ = 0;
         }
         else
         {
            _loc1_ = 1;
         }
         TweenLite.to(disabledImage,!this._questListItemVO.acceptable ? 0.4 : 0,{"alpha":_loc1_});
         if(this._questListItemVO.completed && !this._questListItemVO.type.hasQuestType(QuestTypeModule.QUESTTYPE_CHALLENGE))
         {
            _loc2_ = 1;
         }
         else
         {
            _loc2_ = 0;
         }
         TweenLite.to(completedImage,this._questListItemVO.completed ? 0.4 : 0,{"alpha":_loc2_});
         TweenLite.to(selectedImage,this._questListItemVO.getQuestActive() ? 0.4 : 0,{"alpha":int(this._questListItemVO.getQuestActive())});
         if(_loc1_ > 0)
         {
            rollOverGlowImage.source = this._lockedBitmapData;
         }
         else if(this._questListItemVO.getQuestActive())
         {
            rollOverGlowImage.source = this._inProgressBitmapData;
         }
         else
         {
            rollOverGlowImage.source = this._rollOverBitmapData;
         }
         questTypeIcon.source = ResourceManager.getBitmap("questWin",this._questListItemVO.questMainTypeIcon);
         toolTip = this._questListItemVO.questTitle;
      }
      
      override protected function creationCompleteHandler() : void
      {
         super.creationCompleteHandler();
         this._scale9Rect = new Rectangle(15,17,1,1);
         backgroundImage.source = this._normalBitmapData;
         selectedImage.source = this._selectedBitmapData;
         disabledImage.source = this._disabledBitmapData;
         if(rollOverGlowImage.source == null)
         {
            rollOverGlowImage.source = this._rollOverBitmapData;
         }
         inProgressGlowImage.source = this._inProgressBitmapData;
         completedImage.source = this._completedBitmapData;
         lockedGlowImage.source = this._lockedBitmapData;
         backgroundImage.scale9Grid = selectedImage.scale9Grid = rollOverGlowImage.scale9Grid = inProgressGlowImage.scale9Grid = disabledImage.scale9Grid = completedImage.scale9Grid = lockedGlowImage.scale9Grid = this._scale9Rect;
      }
      
      override protected function clickHandler(param1:MouseEvent) : void
      {
         super.clickHandler(param1);
         var _loc2_:QuestGiverWindowEvent = new QuestGiverWindowEvent(QuestGiverWindowEvent.GET_DETAILED_QUEST_INFO,true);
         _loc2_.questID = this._questListItemVO.questID;
         _loc2_.rootCaseID = this._questListItemVO.rootCaseID;
         dispatchEvent(_loc2_);
      }
      
      override protected function rollHandler(param1:MouseEvent) : void
      {
         TweenLite.to(rollOverGlowImage,0.3,{"alpha":int(param1.type == MouseEvent.ROLL_OVER)});
      }
      
      override protected function stateChangeCompleteHandler() : void
      {
         backgroundImage.scale9Grid = this._scale9Rect;
         inProgressGlowImage.scale9Grid = this._scale9Rect;
         rollOverGlowImage.scale9Grid = this._scale9Rect;
      }
      
      public function set questListItemVO(param1:QuestListItemVO) : void
      {
         this._questListItemVO = param1;
         this.init();
         this.creationCompleteHandler();
      }
      
      public function get questListItemVO() : QuestListItemVO
      {
         return this._questListItemVO;
      }
      
      [Bindable(event="propertyChange")]
      private function get _normalBitmapData() : BitmapData
      {
         return this._1106023393_normalBitmapData;
      }
      
      private function set _normalBitmapData(param1:BitmapData) : void
      {
         var _loc2_:Object = this._1106023393_normalBitmapData;
         if(_loc2_ !== param1)
         {
            this._1106023393_normalBitmapData = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_normalBitmapData",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _scale9Rect() : Rectangle
      {
         return this._1318480814_scale9Rect;
      }
      
      private function set _scale9Rect(param1:Rectangle) : void
      {
         var _loc2_:Object = this._1318480814_scale9Rect;
         if(_loc2_ !== param1)
         {
            this._1318480814_scale9Rect = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_scale9Rect",_loc2_,param1));
            }
         }
      }
   }
}

