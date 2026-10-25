package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class RewardTitleModule extends RewardContentModule
   {
      
      private static var _instance:RewardTitleModule;
      
      public var titleKey:String = "";
      
      public function RewardTitleModule(param1:String = "")
      {
         super();
         this.titleKey = param1;
      }
      
      public static function get instance() : RewardTitleModule
      {
         return _instance || (_instance = new RewardTitleModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 22604;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.titleKey = param1.readUTF();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(22604);
         super.write(param1);
         param1.writeUTF(this.titleKey);
      }
   }
}

