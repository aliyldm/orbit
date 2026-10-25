package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class EpicFightMessageTypeModule extends EpicFightMessageModule
   {
      
      private static var _instance:EpicFightMessageTypeModule;
      
      public static const EPICMIGHTMESSAGETYPE_ROUND_WIN:int = 0;
      
      public static const EPICMIGHTMESSAGETYPE_ROUND_LOSE:int = 1;
      
      public static const EPICMIGHTMESSAGETYPE_FIGHT:int = 2;
      
      public static const EPICMIGHTMESSAGETYPE_FINAL_ROUND:int = 3;
      
      public static const EPICMIGHTMESSAGETYPE_DOUBLE_KO:int = 4;
      
      public static const EPICMIGHTMESSAGETYPE_DRAW:int = 5;
      
      public static const EPICMIGHTMESSAGETYPE_ROUND_OVER:int = 6;
      
      public static const EPICMIGHTMESSAGETYPE__MAX:int = 7;
      
      public var type:int = 0;
      
      public function EpicFightMessageTypeModule(param1:int = 0)
      {
         super();
         this.type = param1;
      }
      
      public static function get instance() : EpicFightMessageTypeModule
      {
         return _instance || (_instance = new EpicFightMessageTypeModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -1183;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.type = param1.readShort();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-1183);
         super.write(param1);
         param1.writeShort(this.type);
      }
   }
}

