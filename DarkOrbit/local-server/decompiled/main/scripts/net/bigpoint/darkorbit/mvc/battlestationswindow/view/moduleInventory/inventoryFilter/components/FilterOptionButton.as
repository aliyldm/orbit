package net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.inventoryFilter.components
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
   import mx.filters.*;
   import mx.styles.*;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.moduleInventory.inventoryFilter.skins.FilterOptionButtonSkin;
   
   public class FilterOptionButton extends FilterOptionButtonBase
   {
      
      private static var _skinParts:Object = {
         "labelDisplay":false,
         "iconDisplay":false
      };
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function FilterOptionButton()
      {
         super();
         this.styleName = "filterOptionButton";
         this.percentWidth = 100;
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
            this.skinClass = FilterOptionButtonSkin;
         };
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
   }
}

