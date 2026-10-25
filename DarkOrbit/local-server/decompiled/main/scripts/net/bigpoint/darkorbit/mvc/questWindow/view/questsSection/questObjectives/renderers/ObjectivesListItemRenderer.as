package net.bigpoint.darkorbit.mvc.questWindow.view.questsSection.questObjectives.renderers
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.SolidColor;
   import mx.states.State;
   import mx.styles.*;
   import net.bigpoint.darkorbit.questfm.Quest;
   import net.bigpoint.darkorbit.questfm.QuestTreeComponent;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   import spark.components.supportClasses.ItemRenderer;
   import spark.core.SpriteVisualElement;
   import spark.primitives.Rect;
   
   public class ObjectivesListItemRenderer extends ItemRenderer implements IStateClient2
   {
      
      private var _1181018375rectBacground:Rect;
      
      private var _22926717treeContainer:SpriteVisualElement;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _treeComponent:QuestTreeComponent;
      
      public function ObjectivesListItemRenderer()
      {
         super();
         mx_internal::_document = this;
         this.autoDrawBackground = false;
         this.top = 0;
         this.bottom = 0;
         this.percentWidth = 100;
         this.mxmlContent = [this._ObjectivesListItemRenderer_Rect1_i(),this._ObjectivesListItemRenderer_SpriteVisualElement1_i()];
         this.currentState = "normal";
         this.addEventListener("dataChange",this.___ObjectivesListItemRenderer_ItemRenderer1_dataChange);
         states = [new State({
            "name":"normal",
            "overrides":[]
         }),new State({
            "name":"hovered",
            "overrides":[]
         }),new State({
            "name":"selected",
            "overrides":[]
         })];
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         var factory:IFlexModuleFactory = param1;
         super.moduleFactory = factory;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration(null,styleManager);
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.contentBackgroundAlpha = 0;
            this.paragraphSpaceAfter = 0;
            this.paragraphEndIndent = 0;
            this.paragraphSpaceBefore = 0;
            this.paragraphStartIndent = 0;
         };
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
      }
      
      private function dataChangeHandler() : void
      {
         while(this.treeContainer.numChildren)
         {
            this.treeContainer.removeChildAt(0);
         }
         if(this.questData != null)
         {
            this._treeComponent = new QuestTreeComponent();
            this._treeComponent.quest = this.questData;
            this._treeComponent.x = 5;
            this._treeComponent.y = 0;
            this._treeComponent.isDefaultVisible = true;
            this._treeComponent.setSize(this.width,300);
            this._treeComponent.update(false);
            this._treeComponent.updateBranches();
            this._treeComponent.addEventListener(QuestTreeComponent.SIZE_CHANGED,this.updateLayout);
            this.treeContainer.addChild(this._treeComponent);
            addEventListener(MouseEvent.CLICK,this.listener);
            this.updateLayout();
         }
         else
         {
            MovieClipUtils.removeDisplayObject(this._treeComponent);
         }
      }
      
      private function listener(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(QuestTreeComponent.SIZE_CHANGED,true));
         this.updateLayout();
      }
      
      private function updateLayout(param1:Event = null) : void
      {
         this.rectBacground.height = this._treeComponent.y + this._treeComponent.visibleHeight + 10;
      }
      
      private function get questData() : Quest
      {
         return data as Quest;
      }
      
      private function _ObjectivesListItemRenderer_Rect1_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.right = 0;
         _loc1_.left = 0;
         _loc1_.fill = this._ObjectivesListItemRenderer_SolidColor1_c();
         _loc1_.initialized(this,"rectBacground");
         this.rectBacground = _loc1_;
         BindingManager.executeBindings(this,"rectBacground",this.rectBacground);
         return _loc1_;
      }
      
      private function _ObjectivesListItemRenderer_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 1712165;
         _loc1_.alpha = 1;
         return _loc1_;
      }
      
      private function _ObjectivesListItemRenderer_SpriteVisualElement1_i() : SpriteVisualElement
      {
         var _loc1_:SpriteVisualElement = new SpriteVisualElement();
         _loc1_.horizontalCenter = -130;
         _loc1_.initialized(this,"treeContainer");
         this.treeContainer = _loc1_;
         BindingManager.executeBindings(this,"treeContainer",this.treeContainer);
         return _loc1_;
      }
      
      public function ___ObjectivesListItemRenderer_ItemRenderer1_dataChange(param1:FlexEvent) : void
      {
         this.dataChangeHandler();
      }
      
      [Bindable(event="propertyChange")]
      public function get rectBacground() : Rect
      {
         return this._1181018375rectBacground;
      }
      
      public function set rectBacground(param1:Rect) : void
      {
         var _loc2_:Object = this._1181018375rectBacground;
         if(_loc2_ !== param1)
         {
            this._1181018375rectBacground = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rectBacground",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get treeContainer() : SpriteVisualElement
      {
         return this._22926717treeContainer;
      }
      
      public function set treeContainer(param1:SpriteVisualElement) : void
      {
         var _loc2_:Object = this._22926717treeContainer;
         if(_loc2_ !== param1)
         {
            this._22926717treeContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"treeContainer",_loc2_,param1));
            }
         }
      }
   }
}

