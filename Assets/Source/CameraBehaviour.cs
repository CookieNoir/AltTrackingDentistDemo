using UnityEngine;

public class CameraBehaviour : MonoBehaviour
{
    [SerializeField] private Transform _target;
    [SerializeField, Min(0.01f)] private float _rotationSpeed = 10f;
    [SerializeField, Min(0f)] private float _angleThreshold = 10f;
    private Quaternion _targetRotation;

    private void Update()
    {
        if (_target != null)
        {
            transform.position = _target.position;
            Quaternion possibleTarget = Quaternion.Euler(0f, _target.rotation.eulerAngles.y, 0f);
            if (Quaternion.Angle(transform.rotation, possibleTarget) > _angleThreshold)
            {
                _targetRotation = possibleTarget;
            }
            transform.rotation = Quaternion.Slerp(transform.rotation, _targetRotation, _rotationSpeed * Time.deltaTime);
        }
    }
}
