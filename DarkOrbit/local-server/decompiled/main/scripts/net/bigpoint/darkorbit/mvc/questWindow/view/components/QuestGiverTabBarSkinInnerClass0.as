package net.bigpoint.darkorbit.mvc.questWindow.view.components
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
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.mvc.common.view.components.DOTabButtonBase;
   import net.bigpoint.darkorbit.mvc.common.view.skins.DOTabButtonBaseSkin;
   
   public class QuestGiverTabBarSkinInnerClass0 extends DOTabButtonBase
   {
      
      private static var _skinParts:Object = {
         "labelDisplay":false,
         "iconDisplay":false
      };
      
      private var _88844982outerDocument:QuestGiverTabBarSkin;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function QuestGiverTabBarSkinInnerClass0()
      {
         super();
         this.percentWidth = 100;
         this.styleName = "questWindowTabs";
         this.mouseChildren = false;
         this.buttonMode = true;
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
            this.fontFamily = "EurostileTHea";
            this.fontSize = 14;
            this.skinClass = DOTabButtonBaseSkin;
         };
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get outerDocument() : QuestGiverTabBarSkin
      {
         return this._88844982outerDocument;
      }
      
      public function set outerDocument(param1:QuestGiverTabBarSkin) : void
      {
         var _loc2_:Object = this._88844982outerDocument;
         if(_loc2_ !== param1)
         {
            this._88844982outerDocument = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"outerDocument",_loc2_,param1));
            }
         }
      }
   }
}

