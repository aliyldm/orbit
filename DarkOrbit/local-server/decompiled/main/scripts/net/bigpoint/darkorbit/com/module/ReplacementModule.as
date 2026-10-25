package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ReplacementModule implements IModule
   {
      
      private static var _instance:ReplacementModule;
      
      public var value:String = "";
      
      public var regex:String = "";
      
      public function ReplacementModule(param1:String = "", param2:String = "")
      {
         super();
         this.value = param2;
         this.regex = param1;
      }
      
      public static function get instance() : ReplacementModule
      {
         return _instance || (_instance = new ReplacementModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7032;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.value = param1.readUTF();
         this.regex = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7032);
         param1.writeUTF(this.value);
         param1.writeUTF(this.regex);
      }
   }
}

