package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ProActionBarOpenStateChangeRequest implements IModule
   {
      
      private static var _instance:ProActionBarOpenStateChangeRequest;
      
      public var proActionBarOpened:Boolean = false;
      
      public function ProActionBarOpenStateChangeRequest(param1:Boolean = false)
      {
         super();
         this.proActionBarOpened = param1;
      }
      
      public static function get instance() : ProActionBarOpenStateChangeRequest
      {
         return _instance || (_instance = new ProActionBarOpenStateChangeRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 12937;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.proActionBarOpened = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(12937);
         param1.writeBoolean(this.proActionBarOpened);
      }
   }
}

