package net.bigpoint.darkorbit.map.model.traits
{
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   
   public class UberBackgroundDisplayTrait extends EntityTraitBase
   {
      
      private var _decorators:Vector.<String>;
      
      private var _debug:Boolean = false;
      
      private var _descriptor:XML;
      
      private var _parallaxFactor:int;
      
      private var _layer:int;
      
      private var _viewDescriptorResKey:String;
      
      public function UberBackgroundDisplayTrait(param1:int, param2:int, param3:String, param4:XML = null, param5:Vector.<String> = null, param6:Boolean = false)
      {
         super();
         this._parallaxFactor = param1;
         this._layer = param2;
         this._viewDescriptorResKey = param3;
         this._decorators = param5;
         this._debug = param6;
         this._descriptor = param4;
      }
      
      public function get parallaxFactor() : int
      {
         return this._parallaxFactor;
      }
      
      public function get layer() : int
      {
         return this._layer;
      }
      
      public function get viewDescriptorResKey() : String
      {
         return this._viewDescriptorResKey;
      }
      
      public function get decorators() : Vector.<String>
      {
         return this._decorators;
      }
      
      public function get debug() : Boolean
      {
         return this._debug;
      }
      
      public function get descriptor() : XML
      {
         return this._descriptor;
      }
   }
}

