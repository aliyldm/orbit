package net.bigpoint.darkorbit.mvc.targetedOffersWindow.model
{
   public class TargetedOfferPattern
   {
      
      private var _id:String;
      
      private var _gfxKey:String;
      
      public function TargetedOfferPattern(param1:String, param2:String)
      {
         super();
         this._gfxKey = param2;
         this._id = param1;
      }
      
      public function get gfxKey() : String
      {
         return this._gfxKey;
      }
      
      public function get id() : String
      {
         return this._id;
      }
   }
}

