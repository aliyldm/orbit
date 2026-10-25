package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DeleteClanRequest implements IModule
   {
      
      private static var _instance:DeleteClanRequest;
      
      public function DeleteClanRequest()
      {
         super();
      }
      
      public static function get instance() : DeleteClanRequest
      {
         return _instance || (_instance = new DeleteClanRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24284;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-24284);
      }
   }
}

