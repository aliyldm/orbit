package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.reward.model
{
   public class SpaceSearchListVO
   {
      
      public var rewards:Vector.<SSReward> = new Vector.<SSReward>();
      
      public var _text:String;
      
      public function SpaceSearchListVO()
      {
         super();
      }
      
      public function get text() : String
      {
         if(!this._text)
         {
            this._text = "test";
         }
         return this._text;
      }
   }
}

