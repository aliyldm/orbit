package net.bigpoint.darkorbit.audio
{
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class AudioMultiPattern extends AudioPattern
   {
      
      protected var _resKeyList:Vector.<String> = new Vector.<String>();
      
      public function AudioMultiPattern(param1:int, param2:String)
      {
         super(param1,param2);
      }
      
      override public function get resKey() : String
      {
         var _loc1_:int = this.resKeyList.length > 1 ? FastMath.getRandomCount(0,this.resKeyList.length - 1) : 0;
         return this._resKeyList[_loc1_];
      }
      
      override public function set resKey(param1:String) : void
      {
         this._resKeyList.push(param1);
      }
      
      public function get resKeyList() : Vector.<String>
      {
         return this._resKeyList;
      }
   }
}

