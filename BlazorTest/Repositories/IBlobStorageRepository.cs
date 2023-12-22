using System.IO;
using System.Threading.Tasks;

namespace BlazorTest.Repositories;

public interface IBlobStorageRepository
{
    Task SaveAsync(string blobName, Stream content);
    Task SaveAsync(string blobName, string content);
    Task<string> GetAsync(string blobName);
}

