package net.bigpoint.darkorbit.com.module.porting
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class NormalTipsCommand implements IModule
   {
      
      private static var _instance:NormalTipsCommand;
      
      public var messageKey:String = "";
      
      public function NormalTipsCommand(param1:String = "")
      {
         super();
         this.messageKey = param1;
      }
      
      public static function get instance() : NormalTipsCommand
      {
         return _instance || (_instance = new NormalTipsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27710;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.messageKey = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(27710);
         param1.writeUTF(this.messageKey);
      }
   }
}

