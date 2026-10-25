package net.bigpoint.darkorbit.mvc.commandCenter.view
{
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.components.list.slideshow.ItemSlideShow;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.commandCenter.constants.CommandCenterConsts;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterCategory;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterNewsVO;
   import org.osflash.signals.Signal;
   
   public class CommandCenterMainSection
   {
      
      public static const INDEX:BindableInt = new BindableInt();
      
      public const clicked:Signal = new Signal();
      
      private var _data:CommandCenterCategory;
      
      private var _viewCache:FuiComponentSelectorCache;
      
      public function CommandCenterMainSection(param1:Sprite)
      {
         super();
         this._viewCache = new FuiComponentSelectorCache(param1);
         this.slideShow.itemDataAssigner = CommandCenterSlideShowAssigner;
         this.categoriesRadioList.itemDataAssigner = DottedListAssigner;
         this.categoriesRadioList.selectedIndex = 0;
         this.categoriesRadioList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleDottedListSelectionChanged);
         this.btnRight.addEventListener(MouseEvent.CLICK,this.handleClickRight);
         this.btnLeft.addEventListener(MouseEvent.CLICK,this.handleClickLeft);
      }
      
      public function get slideShow() : ItemSlideShow
      {
         return this._viewCache.selectComponent("contentContainer.commandCenterNews.slideShow") as ItemSlideShow;
      }
      
      public function set data(param1:CommandCenterCategory) : void
      {
         if(param1 == this._data)
         {
            return;
         }
         if(this._data)
         {
            this._data.changed.remove(this.handleChange);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.handleChange);
         }
         INDEX.value = 0;
         this.assignSkins(this._data.isSpecial);
         this.handleChange();
         setTimeout(this.updateTottedList,1);
         this.contentClicked();
      }
      
      private function get btnRight() : Coreponent
      {
         return this._viewCache.selectComponent("contentContainer.commandCenterNews.newsContentArrowRight") as Coreponent;
      }
      
      private function get btnLeft() : Coreponent
      {
         return this._viewCache.selectComponent("contentContainer.commandCenterNews.newsContentArrowLeft") as Coreponent;
      }
      
      private function get categoriesRadioList() : ItemList
      {
         return this._viewCache.selectComponent("contentContainer.commandCenterNews.categoriesRadioList") as ItemList;
      }
      
      private function get newsBackground() : Coreponent
      {
         return this._viewCache.selectComponent("contentContainer.commandCenterNews.newsBackground") as Coreponent;
      }
      
      private function get newsContentFrameBox() : Coreponent
      {
         return this._viewCache.selectComponent("contentContainer.commandCenterNews.newsContentFrameBox") as Coreponent;
      }
      
      private function get newsContentFrameLine() : Coreponent
      {
         return this._viewCache.selectComponent("contentContainer.commandCenterNews.newsContentFrameLine") as Coreponent;
      }
      
      private function get newsContentFrameLine2() : Coreponent
      {
         return this._viewCache.selectComponent("contentContainer.commandCenterNews.newsContentFrameLine2") as Coreponent;
      }
      
      public function showNext() : void
      {
         this.handleClickRight();
      }
      
      private function handleChange() : void
      {
         this.categoriesRadioList.visible = this.btnLeft.visible = this.btnRight.visible = this._data.listOfNews.length > 1;
         this.categoriesRadioList.list = this.slideShow.list = new VectorCollection(this._data.listOfNews);
      }
      
      private function assignSkins(param1:Boolean) : void
      {
         if(param1)
         {
            this.newsBackground.registeredSkinName = CommandCenterConsts.CONTENT_BG_SPECIAL;
            this.newsContentFrameBox.registeredSkinName = CommandCenterConsts.CONTENT_BOX_SPECIAL;
            this.newsContentFrameLine2.registeredSkinName = this.newsContentFrameLine.registeredSkinName = CommandCenterConsts.CONTENT_LINE_SPECIAL;
         }
         else
         {
            this.newsBackground.registeredSkinName = CommandCenterConsts.CONTENT_BG;
            this.newsContentFrameBox.registeredSkinName = CommandCenterConsts.CONTENT_BOX;
            this.newsContentFrameLine2.registeredSkinName = this.newsContentFrameLine.registeredSkinName = CommandCenterConsts.CONTENT_LINE;
         }
      }
      
      private function updateTottedList() : void
      {
         INDEX.value = this.categoriesRadioList.selectedIndex = this.slideShow.index;
      }
      
      private function contentClicked() : void
      {
         var _loc1_:CommandCenterNewsVO = null;
         if(this.slideShow.index >= 0 && this._data.listOfNews.length > this.slideShow.index)
         {
            _loc1_ = this._data.listOfNews[this.slideShow.index];
            if(_loc1_)
            {
               this.clicked.dispatch(_loc1_);
            }
         }
      }
      
      private function handleDottedListSelectionChanged(param1:ItemListEvent) : void
      {
         var _loc2_:int = this.categoriesRadioList.selectedIndex;
         this.slideShow.index = _loc2_;
         this.contentClicked();
      }
      
      private function handleClickLeft(param1:MouseEvent = null) : void
      {
         --this.slideShow.index;
         this.updateTottedList();
      }
      
      private function handleClickRight(param1:MouseEvent = null) : void
      {
         ++this.slideShow.index;
         this.updateTottedList();
      }
   }
}

import com.greensock.TweenLite;
import com.greensock.TweenMax;
import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterNewsVO;

class DottedListAssigner extends DefaultItemDataAssigner
{
   
   private var _btn:Button;
   
   private var _tween:TweenLite;
   
   public function DottedListAssigner()
   {
      super();
   }
   
   override public function assignChildren() : void
   {
      super.assignChildren();
      this._btn = FuiComponentSelectorUtil.selectComponent("btn",this) as Button;
   }
   
   override public function set data(param1:Object) : void
   {
      var _loc2_:CommandCenterNewsVO = data as CommandCenterNewsVO;
      if(_loc2_)
      {
         _loc2_.isNew.changed.remove(this.animateIsNew);
      }
      super.data = param1;
      _loc2_ = data as CommandCenterNewsVO;
      if(_loc2_)
      {
         _loc2_.isNew.changed.add(this.animateIsNew);
      }
      this.animateIsNew();
   }
   
   private function animateIsNew() : void
   {
      var _loc1_:CommandCenterNewsVO = data as CommandCenterNewsVO;
      if(Boolean(_loc1_) && _loc1_.isNew.value)
      {
         this.createTween();
      }
      else
      {
         this.killTween();
      }
   }
   
   private function killTween() : void
   {
      if(this._tween)
      {
         this._tween.complete();
         this._tween.kill();
         this._tween = null;
      }
   }
   
   private function createTween() : void
   {
      if(!this._tween)
      {
         this._tween = TweenMax.to(this._btn,1,{
            "yoyo":true,
            "repeat":-1,
            "repeatDelay":1,
            "colorMatrixFilter":{
               "brightness":1.5,
               "contrast":1.5,
               "saturation":1.5,
               "hue":350
            }
         });
      }
   }
   
   override protected function drawSelection() : void
   {
      this._btn.enabled = !isSelected();
   }
   
   override public function dispose() : void
   {
      this.killTween();
      super.dispose();
   }
}
