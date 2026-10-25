package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class RogueLiteRankInfoCommand extends RankInfoCommand
   {
      
      private static var _instance:RogueLiteRankInfoCommand;
      
      public function RogueLiteRankInfoCommand(param1:Vector.<RankModule> = null, param2:RankModule = null)
      {
         super(param1,param2);
      }
      
      public static function get instance() : RogueLiteRankInfoCommand
      {
         return _instance || (_instance = new RogueLiteRankInfoCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -18627;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-18627);
         super.write(param1);
      }
   }
}

