package net.bigpoint.darkorbit.mvc.commandCenter.view
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.text.TextField;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.layout.Alignment;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.text.label.LabelSkin;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.commandCenter.constants.CommandCenterConsts;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterCategory;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class CommandCenterCategoryListDataAssigner extends DefaultItemDataAssigner
   {
      
      private var _state:Coreponent;
      
      private var _hover:Coreponent;
      
      private var _mark:Coreponent;
      
      private var _hasNewsMark:Coreponent;
      
      private var _img:Coreponent;
      
      private var _categoryName:Label;
      
      private var _categoryTimer:Label;
      
      private var _uiLib:SWFFinisher;
      
      public function CommandCenterCategoryListDataAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         if(param1 != data)
         {
            this.removeListeners();
            super.data = param1;
            if(data)
            {
               this.update();
            }
         }
         else
         {
            super.data = param1;
         }
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._uiLib = ResourceManager.fileCollection.getFinisher(CommandCenterConsts.ASSET_LIB) as SWFFinisher;
         this._state = FuiComponentSelectorUtil.selectComponent("state",this) as Coreponent;
         this._hover = FuiComponentSelectorUtil.selectComponent("hover",this) as Coreponent;
         this._mark = FuiComponentSelectorUtil.selectComponent("mark",this) as Coreponent;
         this._mark.visible = false;
         this._hasNewsMark = FuiComponentSelectorUtil.selectComponent("hasNewsMark",this) as Coreponent;
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._categoryName = FuiComponentSelectorUtil.selectComponent("category.category_string",this) as Label;
         this._categoryTimer = FuiComponentSelectorUtil.selectComponent("category.category_timer",this) as Label;
      }
      
      override public function select() : void
      {
         super.select();
         CommandCenterMainSection.INDEX.changed.add(this.updateText);
         this.updateText();
         this._mark.visible = true;
         this._hover.visible = this._state.visible = false;
      }
      
      override public function unselect() : void
      {
         super.unselect();
         CommandCenterMainSection.INDEX.changed.remove(this.updateText);
         this._mark.visible = false;
         this._hover.visible = this._state.visible = true;
      }
      
      private function removeListeners() : void
      {
         CommandCenterMainSection.INDEX.changed.remove(this.updateText);
         var _loc1_:CommandCenterCategory = data as CommandCenterCategory;
         if(_loc1_)
         {
            _loc1_.hasUnreadNews.changed.remove(this.updateHasNews);
            _loc1_.timer.changed.remove(this.updateTimer);
         }
      }
      
      private function update() : void
      {
         var _loc1_:CommandCenterCategory = data as CommandCenterCategory;
         this.assignSkins(_loc1_.isSpecial);
         _loc1_.hasUnreadNews.changed.add(this.updateHasNews);
         _loc1_.timer.changed.add(this.updateTimer);
         this.updateText();
         this.handleItemLoaded();
         this.updateHasNews();
         this.updateTimer();
      }
      
      private function updateText() : void
      {
         var _loc1_:CommandCenterCategory = data as CommandCenterCategory;
         this._categoryName.text = _loc1_.getSpecialText(CommandCenterMainSection.INDEX.value) || BPLocale.getItemInCategory("bn",_loc1_.textKey);
         this._categoryName.forceRedraw(InvalidationType.TEXT);
         var _loc2_:Number = _loc1_.timer.value;
         if(_loc2_ > 0)
         {
            this._categoryTimer.text = TimeFormatter.getSmartFormatedTimeSmall(_loc2_);
         }
         else
         {
            this._categoryTimer.text = "";
         }
         var _loc3_:TextField = (this._categoryName.skin as LabelSkin).textField;
         if(_loc3_.numLines > 1)
         {
            this._categoryName.alignY = null;
            this._categoryName.height = 30;
            this._categoryName.y = -(this._categoryName.parent.height * 0.5) + this._categoryName.height * 0.5;
         }
         else
         {
            this._categoryName.height = 20;
            this._categoryName.alignY = Alignment.CENTER_Y;
            this._categoryName.y = 0;
         }
      }
      
      private function assignSkins(param1:Boolean) : void
      {
         this._mark.registeredSkinName = param1 ? CommandCenterConsts.LIST_BG_SPECIAL : CommandCenterConsts.LIST_BG;
         this._hover.registeredSkinName = param1 ? CommandCenterConsts.LIST_HOVER_SPECIAL : CommandCenterConsts.LIST_HOVER;
      }
      
      private function updateHasNews() : void
      {
         var _loc1_:CommandCenterCategory = data as CommandCenterCategory;
         this._hasNewsMark.visible = _loc1_.hasUnreadNews.value;
      }
      
      private function handleItemLoaded() : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         var _loc1_:CommandCenterCategory = data as CommandCenterCategory;
         if(_loc1_)
         {
            this._img.addChild(this._uiLib.getEmbeddedBitmap("icon_" + _loc1_.id.toLocaleLowerCase()));
         }
      }
      
      private function updateTimer() : void
      {
         var _loc1_:CommandCenterCategory = data as CommandCenterCategory;
         var _loc2_:Number = _loc1_.timer.value;
         if(_loc2_ > 0)
         {
            this._categoryTimer.text = TimeFormatter.getSmartFormatedTimeSmall(_loc2_);
         }
         else
         {
            this._categoryTimer.text = "";
         }
      }
   }
}

