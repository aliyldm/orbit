package Infinicast.Client.Api
{
   public interface IStormSettings
   {
      
      function createOrUpdateRole(param1:String, param2:RoleSettings, param3:Function = null) : void;
      
      function destroyRole(param1:String, param2:Function = null) : void;
   }
}

